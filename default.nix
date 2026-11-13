{ pkgs ? import <nixpkgs> {}
, lib ? pkgs.lib
, runCommand ? pkgs.runCommand
, makeBinaryWrapper ? pkgs.makeBinaryWrapper

, shellcheck ? pkgs.shellcheck

, bat ? pkgs.bat

, inNixShell ? false

, useBatWithConfettiInShell ? false
}:

let
  projectName = "sublime-text-confetti";

  shell = pkgs.mkShell {
    pname = "${projectName}-shell";

    packages = [
      shellcheck
      (if useBatWithConfettiInShell then bat-with-confetti else bat)
    ];
  };

  # A `bat` wrapper with Confetti syntax/language included
  bat-with-confetti =
    runCommand "bat-with-confetti-${bat.version}" {
      nativeBuildInputs = [
        bat
        makeBinaryWrapper
      ];

      meta = {
        description = "bat with Confetti syntax highlighting included";
        mainProgram = "bat";
      };
    } ''
      mkdir -p "$out/bin" "$out/share/bat/syntaxes"
      cp ${./Confetti.sublime-syntax} "$out/share/bat/syntaxes/Confetti.sublime-syntax"

      bat cache --build \
        --source "$out/share/bat" \
        --target "$out/share/bat/cache"

      makeWrapper ${lib.escapeShellArg (lib.getExe pkgs.bat)} "$out/bin/bat" \
        --set BAT_CACHE_PATH "$out/share/bat/cache"

      "$out/bin/bat" --list-languages | grep -iq confetti
    '';
in

(if inNixShell then shell else {}) // {
  inherit
    shell
    bat-with-confetti
    ;
}
