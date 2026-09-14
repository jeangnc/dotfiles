import os
from pathlib import Path
import shlex
import subprocess
import tempfile
import unittest


SELECTOR = Path(__file__).parent.parent / "zsh" / "docker-host.zsh"
ROOTS = {
    "/Users/jeangnc/Code/gq": "ssh://gq@orb",
    "/Users/jeangnc/Code/jeangnc": "ssh://me@orb",
    "/Users/jeangnc/Code/skip-visa-queue": "ssh://svq@orb",
}
STATE = 'printf "%s\\n" "${DOCKER_HOST-<unset>}" "${DOCKER_CONTEXT-<unset>}" "${DOTFILES_DOCKER_HOST_AUTO-<unset>}"'


class DirectoryDockerHostTest(unittest.TestCase):
    def setUp(self):
        self.startup = tempfile.TemporaryDirectory(
            prefix="zsh-startup.", dir=Path(__file__).parent
        )
        self.addCleanup(self.startup.cleanup)
        self.docker_config = Path(self.startup.name, "docker")
        Path(self.startup.name, ".zshenv").write_text(
            f"source {shlex.quote(str(SELECTOR))}\n"
        )

    def run_shell(self, code=STATE, cwd="/private/tmp", extra_env=None, interactive=False):
        environment = os.environ.copy()
        for name in (
            "DOCKER_HOST",
            "DOCKER_CONTEXT",
            "DOCKER_CONFIG",
            "DOTFILES_DOCKER_HOST_AUTO",
        ):
            environment.pop(name, None)
        environment["ZDOTDIR"] = self.startup.name
        environment["DOCKER_CONFIG"] = str(self.docker_config)
        environment.update(extra_env or {})
        result = subprocess.run(
            ["/bin/zsh", "-ic" if interactive else "-c", code],
            cwd=cwd,
            env=environment,
            text=True,
            capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(result.stderr, "")
        return result.stdout.splitlines()

    def test_noninteractive_startup_selects_the_directory_engine(self):
        for root, host in ROOTS.items():
            with self.subTest(root=root):
                self.assertEqual(self.run_shell(cwd=root), [host, "<unset>", host])

    def test_nested_repositories_select_their_owning_engine(self):
        for root, host in ROOTS.items():
            with self.subTest(root=root):
                command = f"PWD={shlex.quote(root + '/nested/repository')}; _dotfiles_docker_host; {STATE}"
                self.assertEqual(self.run_shell(command), [host, "<unset>", host])

    def test_similar_directory_prefixes_do_not_select_an_engine(self):
        for root in ROOTS:
            with self.subTest(root=root):
                command = f"PWD={shlex.quote(root + '-other')}; _dotfiles_docker_host; {STATE}"
                self.assertEqual(self.run_shell(command), ["<unset>"] * 3)

    def test_interactive_directory_changes_replace_the_automatic_host(self):
        command = f"cd /Users/jeangnc/Code/jeangnc; {STATE}"
        self.assertEqual(
            self.run_shell(command, cwd="/Users/jeangnc/Code/gq", interactive=True),
            ["ssh://me@orb", "<unset>", "ssh://me@orb"],
        )

    def test_leaving_managed_directories_clears_the_automatic_host(self):
        self.assertEqual(
            self.run_shell(f"cd /private/tmp; {STATE}", cwd="/Users/jeangnc/Code/gq"),
            ["<unset>"] * 3,
        )

    def test_child_shell_replaces_an_inherited_automatic_host(self):
        self.assertEqual(
            self.run_shell(
                cwd="/Users/jeangnc/Code/jeangnc",
                extra_env={
                    "DOCKER_HOST": "ssh://gq@orb",
                    "DOTFILES_DOCKER_HOST_AUTO": "ssh://gq@orb",
                },
            ),
            ["ssh://me@orb", "<unset>", "ssh://me@orb"],
        )

    def test_child_shell_outside_managed_directories_clears_inherited_host(self):
        self.assertEqual(
            self.run_shell(
                extra_env={
                    "DOCKER_HOST": "ssh://gq@orb",
                    "DOTFILES_DOCKER_HOST_AUTO": "ssh://gq@orb",
                }
            ),
            ["<unset>"] * 3,
        )

    def test_external_worktree_uses_its_main_checkout_engine(self):
        worktree = self.create_external_worktree()
        self.assertEqual(
            self.run_shell(cwd=worktree),
            ["ssh://gq@orb", "<unset>", "ssh://gq@orb"],
        )

    def test_entering_external_worktree_replaces_the_previous_engine(self):
        worktree = self.create_external_worktree()
        self.assertEqual(
            self.run_shell(
                f"cd {shlex.quote(str(worktree))}; {STATE}",
                cwd="/Users/jeangnc/Code/jeangnc",
            ),
            ["ssh://gq@orb", "<unset>", "ssh://gq@orb"],
        )

    def test_worktree_ownership_takes_precedence_over_its_physical_directory(self):
        command = f"git() {{ print -r -- /Users/jeangnc/Code/gq/great_question/.git; }}; PWD=/Users/jeangnc/Code/jeangnc/gq-worktree; _dotfiles_docker_host; {STATE}"
        self.assertEqual(self.run_shell(command), ["ssh://gq@orb", "<unset>", "ssh://gq@orb"])

    def test_explicit_host_survives_startup_and_directory_changes(self):
        self.assertEqual(
            self.run_shell(
                f"cd /Users/jeangnc/Code/jeangnc; {STATE}",
                cwd="/Users/jeangnc/Code/gq",
                extra_env={"DOCKER_HOST": "ssh://manual@example"},
            ),
            ["ssh://manual@example", "<unset>", "<unset>"],
        )

    def test_explicit_context_survives_startup_and_directory_changes(self):
        self.assertEqual(
            self.run_shell(
                f"cd /Users/jeangnc/Code/jeangnc; {STATE}",
                cwd="/Users/jeangnc/Code/gq",
                extra_env={"DOCKER_CONTEXT": "manual"},
            ),
            ["<unset>", "manual", "<unset>"],
        )

    def test_explicit_host_and_context_are_preserved_together(self):
        self.assertEqual(
            self.run_shell(
                cwd="/Users/jeangnc/Code/gq",
                extra_env={
                    "DOCKER_HOST": "ssh://manual@example",
                    "DOCKER_CONTEXT": "manual",
                },
            ),
            ["ssh://manual@example", "manual", "<unset>"],
        )

    def test_explicit_context_removes_an_inherited_automatic_host(self):
        self.assertEqual(
            self.run_shell(
                cwd="/Users/jeangnc/Code/jeangnc",
                extra_env={
                    "DOCKER_HOST": "ssh://gq@orb",
                    "DOTFILES_DOCKER_HOST_AUTO": "ssh://gq@orb",
                    "DOCKER_CONTEXT": "manual",
                },
            ),
            ["<unset>", "manual", "ssh://gq@orb"],
        )

    def test_removing_an_explicit_host_resumes_directory_routing(self):
        self.assertEqual(
            self.run_shell(
                f"unset DOCKER_HOST; cd /Users/jeangnc/Code/jeangnc; {STATE}",
                cwd="/Users/jeangnc/Code/gq",
                extra_env={"DOCKER_HOST": "ssh://manual@example"},
            ),
            ["ssh://me@orb", "<unset>", "ssh://me@orb"],
        )

    def test_loading_twice_registers_one_directory_hook(self):
        self.assertEqual(
            self.run_shell(
                f"source {shlex.quote(str(SELECTOR))}; print ${{#chpwd_functions}}"
            ),
            ["1"],
        )

    def test_docker_resolves_each_automatic_host_without_contacting_it(self):
        command = "docker context inspect --format '{{(index .Endpoints \"docker\").Host}}'"
        for root, host in ROOTS.items():
            with self.subTest(root=root):
                self.assertEqual(self.run_shell(command, cwd=root), [host])

    def test_inline_host_override_reaches_dockers_resolved_endpoint(self):
        command = "DOCKER_HOST=ssh://manual@example docker context inspect --format '{{(index .Endpoints \"docker\").Host}}'"
        self.assertEqual(
            self.run_shell(command, cwd="/Users/jeangnc/Code/gq"),
            ["ssh://manual@example"],
        )

    def test_context_flag_takes_precedence_in_docker(self):
        self.create_manual_context()
        command = "docker --context manual context inspect --format '{{(index .Endpoints \"docker\").Host}}'"
        self.assertEqual(
            self.run_shell(command, cwd="/Users/jeangnc/Code/gq"),
            ["ssh://manual@example"],
        )

    def create_manual_context(self):
        result = subprocess.run(
            [
                "docker", "--config", str(self.docker_config), "context", "create",
                "manual", "--docker", "host=ssh://manual@example",
            ],
            text=True,
            capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stderr)

    def create_external_worktree(self):
        worktree = Path(self.startup.name, "external-worktree")
        metadata = Path(self.startup.name, "git-metadata")
        worktree.mkdir()
        metadata.mkdir()
        Path(worktree, ".git").write_text(f"gitdir: {metadata}\n")
        Path(metadata, "commondir").write_text(
            "/Users/jeangnc/Code/gq/great_question/.git\n"
        )
        Path(metadata, "HEAD").write_text("ref: refs/heads/main\n")
        Path(metadata, "gitdir").write_text(f"{worktree}/.git\n")
        result = subprocess.run(
            ["git", "rev-parse", "--path-format=absolute", "--git-common-dir"],
            cwd=worktree,
            text=True,
            capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(
            result.stdout.strip(), "/Users/jeangnc/Code/gq/great_question/.git"
        )
        return worktree


if __name__ == "__main__":
    unittest.main(verbosity=2)
