# Zelda launcher with pinned upstream files

Security-focused fork of [spiritkiller's package](https://github.com/spiritkiller/The-Legend-of-Zelda-Ocarina-of-Time-Remake-AllinOne-). This branch contains only scripts, documentation and a hash manifest. It does **not** certify Lichii as malware-free.

## What changed

- Removed all bundled executables, DLLs, shader archives, prefilled emulator settings and Lossless Scaling files from this branch's current tree.
- Removed the helper that modified an existing Lossless Scaling installation.
- Replaced the launcher with an installer for one pinned release from [Lichii's own repository](https://github.com/zortos293/Lichii/releases/tag/build-117).
- Check the ZIP's SHA-256 before extraction, check extraction paths, then check all 41 extracted file hashes against `upstream-lock.json`.
- Before every launch, recheck every file and reject missing, modified or extra files, unexpected directories, junctions and symbolic links. An existing `Emulator` directory is never overwritten by the installer.
- No antivirus exclusions, execution-policy bypass, elevation, automatic updates, Lossless Scaling integration or shared shader imports in these scripts.

## Windows setup

1. Download **this fork's `codex/hardened-package` branch** into a new folder. Do not overlay the original package. Use [Download ZIP](https://github.com/zhiru/The-Legend-of-Zelda-Ocarina-of-Time-Remake-AllinOne-/archive/refs/heads/codex/hardened-package.zip).
2. Review `Manage-Emulator.ps1` and `upstream-lock.json`. Run `Prepare.bat` to download and verify the pinned upstream build. Preparation does not start the emulator.
3. Put exactly one legally obtained `.nup` game backup in `ROM_BURAYA_KONACAK`.
4. Run `Start_Game.bat`. `Oyunu_Baslat.bat` is an alias.

No administrator access is needed. The scripts respect your PowerShell execution policy. If Windows marks the downloaded scripts as blocked, review them before using the file's **Properties > Unblock** option. If organizational policy disallows scripts, do not bypass it.

For a verification without launching anything:

```powershell
powershell.exe -NoProfile -File .\Manage-Emulator.ps1 -Mode Verify
```

Keep the `Emulator` folder pristine: do not enable portable mode by creating a `user` directory there, add DLLs, or accept an in-app update. An upstream update will fail the pinned verification. To upgrade, review and update the release URL, archive hash and full file manifest together. Move an existing runtime aside before preparing a replacement; do not delete it without checking saves. The emulator may use existing upstream data in your Windows user profile; this launcher does not isolate or modify that profile. Back up saves before use.

Lossless Scaling is omitted. If wanted, obtain it separately from its publisher through Steam and configure it manually. Shared shader caches were removed because their provenance and compatibility were not established; initial shader compilation may stutter.

## Security limits and audit

See [SECURITY.md](SECURITY.md). A GitHub fork preserves upstream history: the old binaries remain accessible in historical commits and the inherited `main` branch. The hardened branch and its ZIP exclude those files. Do not use the upstream v1.0 release as a hardened build.

The pinned SHA-256 is `da8d154c277d79b05b94f2102b532440d2d6d5c6c462643e75d65689f30ef7dc`. It matched the upstream GitHub release asset digest and our downloaded ZIP on 2026-11-08. These hashes establish correspondence to that upstream package, not that its code is harmless.

## Tests

```powershell
powershell.exe -NoProfile -File .\tests\Test-Hardening.ps1
```

Tests use fake text files named `lichii.exe`; no emulator or game is executed. The original package author's authorship is preserved in Git history. No claim of ownership or new license for upstream third-party material is made.
