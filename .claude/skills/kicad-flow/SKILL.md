---
name: kicad-flow
description: Flujo de trabajo para diseñar, revisar y documentar circuitos en KiCad 10 dentro de este repo (prácticas de Diseño Electrónico IoT). Úsala cuando el usuario quiera crear o modificar un esquemático o PCB, correr ERC/DRC, rutear, exportar renders/Gerbers/BOM, revisar capturas de KiCad o preparar evidencias de una práctica de KiCad.
---

# Flujo KiCad

## Entorno
- KiCad 10.0.5 en Windows. CLI: `/c/Program Files/KiCad/10.0/bin/kicad-cli.exe` (bash).
- Python con `pcbnew`: `/c/Program Files/KiCad/10.0/bin/python.exe` (solo para scripts de PCB; no hay `kipy` y la API IPC está apagada).
- Bibliotecas estándar: `/c/Program Files/KiCad/10.0/share/kicad/{symbols,footprints,3dmodels}`.
- Cada proyecto vive en `NN_<práctica>/<nombre_proyecto>/` y solo se versionan `.kicad_pro`, `.kicad_sch` y `.kicad_pcb` (más libs propias). `.kicad_prl`, backups e `.history` están en `.gitignore`.

## Regla de oro: un solo editor a la vez
Los `.kicad_sch` / `.kicad_pcb` son S-expressions editables como texto, pero KiCad sobrescribe el archivo al guardar.
1. Antes de editar un archivo, pide al usuario que lo cierre en KiCad (si existe un `*.lck` en la carpeta, sigue abierto).
2. Edita, valida con el script y avisa al usuario para que lo vuelva a abrir.
3. Si el usuario editó en KiCad, vuelve a leer el archivo antes de tocarlo. Haz commit antes de cambios grandes para poder revertir.

## Ciclo de diseño
1. **Definir** el circuito con el usuario: función, alimentación, valores calculados (p. ej. R de un LED = (Vbat − Vf) / I).
2. **Esquemático**: símbolos de la biblioteca estándar, etiquetas de red con nombres claros (`vbat`, `gnd`, `led_a`), todas las unidades de un símbolo multi-unidad colocadas o usar un símbolo de una unidad, flags `PWR_FLAG` en redes de alimentación.
3. **ERC** sin errores ni advertencias (o justificadas).
4. **Footprints** coherentes con la pieza real (p. ej. resistencia 1/4 W THT → `Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal`). El usuario ejecuta *Actualizar PCB desde esquemático* (F8) en KiCad.
5. **PCB**: contorno en `Edge.Cuts` (rectángulo cerrado), colocación, ruteo, plano de GND si aplica, textos de serigrafía legibles.
6. **DRC** con paridad esquemático/PCB sin violaciones.
7. **Evidencias**: renders y PDF en la carpeta de la práctica, nota en `_docs/`.

## Verificación y exportación
```bash
bash .claude/skills/kicad-flow/scripts/kicad_check.sh <carpeta_proyecto> [carpeta_salida]
```
Genera `erc.rpt`, `drc.rpt`, esquemático en SVG/PDF, `render_top/bottom/iso.png` y `layout.svg`. Devuelve código 1 si hay violaciones. Mira los PNG con la herramienta Read para revisar el diseño visualmente en vez de depender solo de capturas.

Otros comandos útiles de `kicad-cli`:
- BOM: `sch export bom -o bom.csv <sch>`
- Netlist: `sch export netlist -o net.xml <sch>`
- Fabricación: `pcb export gerbers -o gerbers/ <pcb>` y `pcb export drill -o gerbers/ <pcb>`

## Lectura de capturas del usuario
Las capturas muestran lo que el usuario ve en ese momento (selecciones, errores en pantalla). Contrástalas siempre con los archivos y los reportes: el visor 3D dibuja una placa de relleno aunque no exista `Edge.Cuts`, y la ratsnest (líneas finas) no son pistas.

## Edición de archivos
- Leer el archivo completo antes de editar; conservar `uuid`s existentes y generar nuevos para elementos nuevos.
- Coordenadas en mm; el esquemático usa grilla de 1.27 mm (pines en múltiplos de 2.54).
- Para PCB, preferir scripts con `pcbnew` (cargar, modificar, `board.Save()`) sobre editar texto a mano cuando se trate de pistas o contornos.
- Al cambiar un footprint con `pcbnew` (`FootprintLoad`), conservar la paridad: `SetPath()` del footprint viejo, `SetFPID(LIB_ID("<lib>", "<nombre>"))` con el nombre de biblioteca, copiar los campos (p. ej. `Description`) recorriendo `GetFields()` y reasignar las redes de los pads.
- Los pads sin uso de un símbolo con no-connect deben llevar la red `unconnected-(<Ref><Unidad>-<Pin>-Pad<N>)` en el PCB (lo mismo que hace F8).
- Tras cualquier edición, correr el script de verificación antes de entregar.
