# pcp_frontend

Pixel Code Platform frontend

---

## Status

Currently does not match the recently changed backend contracts. Use [PixelSam123/pcp_frontend_web](https://github.com/PixelSam123/pcp_frontend_web) for now.

## List of modifications to OS-specific builds

1. macOS

   Added this to both `Runner/DebugProfile.entitlements` and `Runner/Release.entitlements`:

   ```xml
   <key>com.apple.security.network.client</key>
   <true/>
   ```
