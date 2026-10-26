---
type: referencia
---

# Práctica #9: Diseño de una fuente de poder en KiCAD

**Fecha:** 25/10/2026
**Estudiante:** Gildardo Estevan Restrepo Duque
**Guía:** Diseño de una fuente de poder en KiCad — Prof. Fabio Guzmán, UPB

---
# Fuente de poder para protoboard — Especificación (v1)

Práctica 09 de Diseño Electrónico IoT. Basada en el módulo de referencia (jack DC → 7805 + LM317 → rieles seleccionables por jumper) con cuatro correcciones: resistencia del LED, valor de C3, divisor del LM317 y protección contra polaridad invertida.

## Requisitos

| Parámetro | Valor |
|---|---|
| Entrada | Adaptador DC 7.5–12 V, centro positivo, jack 5.5 × 2.1 mm. **Recomendado: 9 V** |
| Salidas | +5 V (LM7805) y +3.3 V (LM317), seleccionables por riel con jumper |
| Corriente por riel (ver límites térmicos) | ≈ 200 mA con 12 V · ≈ 280 mA con 9 V |
| Protección | Diodo Schottky en serie contra polaridad invertida |
| Indicador | LED de encendido después del interruptor |
| Placa | 2 capas, ≈ 34 × 52.7 mm con muescas para la protoboard (a confirmar midiendo) |

## Diagrama de bloques

```
J1 (jack) ──D2 1N5819──► PWR_INPUT ──S1──► VIN ─┬─ U1 LM7805 ──► +5V ──┐
                                                ├─ U2 LM317  ──► +3V3 ─┤
                                                └─ R1 + D1 (LED)       │
                         J6/J7 (jumper 5V | 3V3) ◄─────────────────────┘
                              └─► PWR_OUT_TOP / PWR_OUT_BOT ──► J5/J4 (riel) y J3/J2 (bornera)
```

## Redes

| Red | Desde → hasta |
|---|---|
| `VIN_JACK` | J1 pin 1 (centro) → ánodo de D2 |
| `PWR_INPUT` | cátodo de D2 → S1 común (pin 2) |
| `VIN` | S1 pin 1 → U1 VI, U2 VI, C1, R1. *(La referencia la llamaba `12V`; se renombra porque la entrada puede ser 9 V)* |
| `+5V` | U1 VO, C2, J6/J7 pin 3 |
| `+3V3` | U2 VO, R2, C3, J6/J7 pin 1 |
| `ADJ` | U2 ADJ, R2, R3 |
| `PWR_OUT_TOP` | J6 pin 2, J5 pin 2, J3 pin 2 |
| `PWR_OUT_BOT` | J7 pin 2, J4 pin 2, J2 pin 2 |
| `GND` | J1 pines 2 y 3, U1 GND, C1–C3, R3, LED (cátodo), J5/J4/J3/J2 pin 1 |

S1 pin 3 lleva no-connect. Usar los símbolos de potencia `+5V`, `+3V3`, `GND` (librería `power`) en lugar de etiquetas sueltas, y `PWR_FLAG` en `VIN` y `GND`.

## Cálculos

**Diodo de protección (D2, 1N5819):** Schottky 1 A / 40 V, caída ≈ 0.45 V. Con la polaridad invertida bloquea y no circula corriente. La entrada efectiva queda en Vin − 0.45 V, así que el 7805 (que necesita ≥ 7 V) exige un adaptador de ≥ 7.5 V.

**Divisor del LM317 (R2 = 240 Ω, R3 = 390 Ω):**
Vout = 1.25 V × (1 + R3/R2) + I_ADJ × R3 = 1.25 × (1 + 390/240) + 50 µA × 390 ≈ **3.30 V**.
Corriente del divisor = 1.25 V / 240 Ω = **5.2 mA**, por encima de la carga mínima del LM317 (3.5 mA típ.). La referencia (330/560) daba 3.40 V y solo 3.8 mA.

**LED indicador (R1 = 1 kΩ):**

| Entrada | I_LED | P_R1 |
|---|---|---|
| 9 V | 6.6 mA | 43 mW |
| 12 V | 9.6 mA | 91 mW |

La referencia (330 Ω a 12 V) daba ≈ 29 mA y ≈ 0.28 W, por encima de lo que aguanta el LED y la resistencia de 1/4 W.

**Límites térmicos (TO-220 acostado, sin disipador):** θJA ≈ 50 °C/W. Con un presupuesto de 1.5 W por regulador, Tj ≈ 25 + 1.5 × 50 = 100 °C (máx. 125 °C).

| Entrada | Caída 7805 | I máx 5 V | Caída LM317 | I máx 3.3 V |
|---|---|---|---|---|
| 9 V | 3.55 V | ≈ 420 mA | 5.25 V | ≈ 285 mA |
| 12 V | 6.55 V | ≈ 230 mA | 8.25 V | ≈ 180 mA |

Para más corriente hace falta disipador o un regulador conmutado; queda fuera del alcance de esta versión.

## Lista de materiales (BOM)

| Ref | Valor | Símbolo KiCad | Footprint KiCad | Nota |
|---|---|---|---|---|
| J1 | Jack DC 5.5 × 2.1 mm | `Connector:Barrel_Jack_Switch` | `Connector_BarrelJack:BarrelJack_Horizontal` | Confirmar con el jack real |
| D2 | 1N5819 | `Diode:1N5819` | `Diode_THT:D_DO-41_SOD81_P10.16mm_Horizontal` | **Nuevo**: protección de polaridad |
| S1 | EG1218 (SPDT) | `Switch:SW_SPDT` | `Button_Switch_THT:SW_Slide_SPDT_Straight_CK_OS102011MS2Q` | KiCad no trae el EG1218; ver pendientes |
| C1 | 10 µF / 25 V electrolítico | `Device:C_Polarized` | `Capacitor_THT:CP_Radial_D5.0mm_P2.00mm` | Entrada |
| U1 | LM7805 | `Regulator_Linear:LM7805_TO220` | `Package_TO_SOT_THT:TO-220-3_Horizontal_TabDown` | |
| C2 | 0.1 µF cerámico | `Device:C` | `Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P5.00mm` | Salida 5 V |
| U2 | LM317 | `Regulator_Linear:LM317_TO-220` | `Package_TO_SOT_THT:TO-220-3_Horizontal_TabDown` | Pines: 1 ADJ, 2 VO, 3 VI |
| R2 | 240 Ω 1 % 1/4 W | `Device:R` | `Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal` | **Corregido** (antes 330) |
| R3 | 390 Ω 1 % 1/4 W | `Device:R` | ídem | **Corregido** (antes 560) |
| C3 | 10 µF / 16 V electrolítico | `Device:C_Polarized` | `Capacitor_THT:CP_Radial_D5.0mm_P2.00mm` | **Corregido** (antes sin valor) |
| R1 | 1 kΩ 1/4 W | `Device:R` | ídem R2 | **Corregido** (antes 330) |
| D1 | LED rojo 5 mm | `Device:LED` | `LED_THT:LED_D5.0mm` | |
| J6, J7 | Header 1×3 + jumper | `Connector:Conn_01x03_Pin` | `Connector_PinHeader_2.54mm:PinHeader_1x03_P2.54mm_Vertical` | 1 = 3V3, 2 = salida, 3 = 5V |
| J5, J4 | Header 1×2 | `Connector:Conn_01x02_Pin` | `Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical` | Se clavan en el riel; 1 = GND, 2 = salida |
| J3, J2 | Bornera 2 pines 5 mm | `Connector:Screw_Terminal_01x02` | `TerminalBlock_Phoenix:TerminalBlock_Phoenix_MKDS-1,5-2_1x02_P5.00mm_Horizontal` | 1 = GND, 2 = salida |

Opcional recomendado: C4 de 0.1 µF cerámico junto a la entrada del LM317.

## Pendientes antes de la fase 4 (colocación)

- [ ] Medir el EG1218 real (separación de pines). Si no coincide con el CK OS102011MS2Q (2 mm), se hace un footprint propio.
- [ ] Confirmar el modelo del jack DC.
- [ ] Medir en la protoboard la distancia entre los rieles de arriba y de abajo, y qué riel es + y cuál −. Esto fija dónde van J5 y J4 y el alto de la placa.


---
## Enlaces
[[diseno_electronico_iot|Diseño Electrónico IoT]]
