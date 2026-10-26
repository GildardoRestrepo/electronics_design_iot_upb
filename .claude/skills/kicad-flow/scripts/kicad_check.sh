#!/usr/bin/env bash
# Verifica un proyecto KiCad y exporta evidencias.
# Uso: kicad_check.sh <carpeta_del_proyecto> [carpeta_de_salida]
# Salida por defecto: <carpeta_del_proyecto>/out
set -u

PROJ_DIR="${1:?Indica la carpeta del proyecto KiCad}"
OUT_DIR="${2:-$PROJ_DIR/out}"
CLI="${KICAD_CLI:-/c/Program Files/KiCad/10.0/bin/kicad-cli.exe}"

SCH=$(ls "$PROJ_DIR"/*.kicad_sch 2>/dev/null | head -1)
PCB=$(ls "$PROJ_DIR"/*.kicad_pcb 2>/dev/null | head -1)
[ -n "$SCH" ] || { echo "No hay .kicad_sch en $PROJ_DIR"; exit 1; }
NAME=$(basename "$SCH" .kicad_sch)

if ls "$PROJ_DIR"/*.lck >/dev/null 2>&1; then
  echo "AVISO: hay archivos .lck; el proyecto está abierto en KiCad."
fi

mkdir -p "$OUT_DIR"
status=0

echo "== ERC =="
"$CLI" sch erc --severity-error --severity-warning --exit-code-violations \
  -o "$OUT_DIR/erc.rpt" "$SCH" >/dev/null 2>&1 || status=1
grep -E '^\[|ERC messages' "$OUT_DIR/erc.rpt"

"$CLI" sch export svg -o "$OUT_DIR" "$SCH" >/dev/null 2>&1
"$CLI" sch export pdf -o "$OUT_DIR/$NAME.pdf" "$SCH" >/dev/null 2>&1

if [ -n "$PCB" ]; then
  echo "== DRC (con paridad esquemático/PCB) =="
  "$CLI" pcb drc --schematic-parity --severity-error --severity-warning --exit-code-violations \
    -o "$OUT_DIR/drc.rpt" "$PCB" >/dev/null 2>&1 || status=1
  grep -E '^\[|^\*\* Found' "$OUT_DIR/drc.rpt"

  echo "== Renders 3D =="
  "$CLI" pcb render --side top --width 1200 --height 800 -o "$OUT_DIR/render_top.png" "$PCB" >/dev/null 2>&1
  "$CLI" pcb render --side bottom --width 1200 --height 800 -o "$OUT_DIR/render_bottom.png" "$PCB" >/dev/null 2>&1
  "$CLI" pcb render --rotate "-45,0,45" --zoom 0.9 --width 1200 --height 800 -o "$OUT_DIR/render_iso.png" "$PCB" >/dev/null 2>&1
  "$CLI" pcb export svg --layers F.Cu,B.Cu,F.SilkS,Edge.Cuts --mode-single --fit-page-to-board \
    -o "$OUT_DIR/layout.svg" "$PCB" >/dev/null 2>&1
fi

echo "== Archivos en $OUT_DIR =="
ls "$OUT_DIR"
[ $status -eq 0 ] && echo "RESULTADO: sin violaciones" || echo "RESULTADO: hay violaciones (ver .rpt)"
exit $status
