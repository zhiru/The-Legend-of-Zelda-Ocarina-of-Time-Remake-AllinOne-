# Security review and scope

Reviewed on 2026-11-08. Original repository commit: `83cf2f3c45e5e80d2c4d608029df3acc917967e6`.

## Original package findings

- Original v1.0 ZIP SHA-256: `88e06982d921d813602d5469b0018a28f9dfd98ce83866acb23ae52bd3d6374c`. The downloaded archive matched the published hash.
- Microsoft Defender completed a custom scan of its 497 extracted files with no detections. This is a point-in-time result, not proof that the binaries are clean.
- No apparent exfiltration, persistence or antivirus-disabling commands were found in the three launcher/helper scripts inspected.
- `lichii.exe`, `eden-cli.exe`, `LosslessScaling.exe` and application-specific Lossless Scaling DLLs were unsigned. An unsigned binary is not necessarily malicious; their correspondence to publisher builds was not established in the initial audit.
- The advertised VirusTotal links were `/gui/url/` reports. They do not establish a file-hash-based malware scan of the executables. [VirusTotal URL reports](https://docs.virustotal.com/reference/url-info) and [file reports](https://docs.virustotal.com/reference/file-info) are distinct.
- Original emulator settings included a prefilled token-like value. Its validity or purpose was not tested. The settings have been removed from this branch.
- The original helper wrote to an existing user's Lossless Scaling settings. The replacement does not do this.

## Hardened branch trust boundary

`Manage-Emulator.ps1` obtains build-117 from `zortos293/Lichii` and checks its pinned ZIP hash before processing it. `upstream-lock.json` pins every extracted file. Preparation checks the extracted files, and launch checks the runtime again. Preparation refuses an existing target directory, so it cannot silently replace an old installation or its saves.

The [upstream Lichii README](https://github.com/zortos293/Lichii) directs users to its own GitHub releases and warns about unrelated download sites. This identifies the publisher's distribution channel; it does not substitute for reviewing or independently rebuilding its source.

Validation of this branch: the actual upstream ZIP installed successfully using Windows PowerShell 5.1, all 41 files passed a separate verification, and a Microsoft Defender custom scan of the installed files completed without detections on 2026-11-08. Upstream's emulator executables are still unsigned. The regression tests cover intact files, tampering, added DLLs, missing files, unexpected portable directories, junctions, preservation of existing installations, wrong archive hashes, valid installation and ZIP traversal. No emulator binary was executed during these checks.

Not covered: complete reverse engineering, source-to-binary reproducibility, sandbox behavior, game-file exploits, upstream network/update behavior, compromised upstream releases, a compromised Windows account, or changes between verification and process creation. The emulator runs with the current user's privileges and is not sandboxed. Its own built-in functionality is not disabled or independently audited here.

Files and hashes in this repository must be obtained from a trusted revision together. A local attacker who can rewrite the launcher and its manifest can defeat these checks. Do not run the emulator as administrator. Never disable antivirus or add exclusions to make it work.

The old binary blobs remain in the fork's Git history and inherited main branch. This change removes them from the hardened branch's current tree; it does not rewrite upstream history. Download the hardened branch's ZIP for a source-only distribution.
