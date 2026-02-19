#!/usr/bin/env bash
set -euo pipefail

TARGET="${HOME}/.config/labwc/rc.xml"
BACKUP="${TARGET}.bak.$(date +%Y%m%d-%H%M%S)"

mkdir -p "$(dirname "${TARGET}")"

if [[ -f "${TARGET}" ]]; then
  cp -a "${TARGET}" "${BACKUP}"
  echo "Backup created: ${BACKUP}"
fi

cat > "${TARGET}" <<'EOF'
<?xml version="1.0"?>
<labwc_config>

  <core>
    <decoration>server</decoration>
    <autoEnableOutputs>yes</autoEnableOutputs>
    <xwaylandPersistence>no</xwaylandPersistence>
  </core>

  <placement>
    <policy>cascade</policy>
  </placement>

  <focus>
    <followMouse>no</followMouse>
    <raiseOnFocus>no</raiseOnFocus>
  </focus>

  <keyboard>
    <default/>
  </keyboard>

  <mouse>
    <default/>
  </mouse>

  <touch mouseEmulation="no"/>

  <libinput>
    <device category="non-touch">
      <sendEventsMode>no</sendEventsMode>
    </device>

    <device category="touch">
      <sendEventsMode>yes</sendEventsMode>
    </device>
  </libinput>

  <resize>
    <popupShow>Never</popupShow>
  </resize>

  <theme>
    <cornerRadius>8</cornerRadius>
    <dropShadows>no</dropShadows>
  </theme>

</labwc_config>
EOF

echo "Written: ${TARGET}"

if command -v labwc >/dev/null 2>&1; then
  if labwc --reconfigure >/dev/null 2>&1; then
    echo "labwc reconfigured successfully."
  else
    echo "labwc config written. Reconfigure failed (likely no active labwc session)."
    echo "Please run: labwc --reconfigure"
  fi
else
  echo "labwc not found in PATH."
  echo "Config was written; apply it in a labwc session with: labwc --reconfigure"
fi
