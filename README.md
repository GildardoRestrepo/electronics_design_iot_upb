# Diseño Electrónico — UPB

Este repositorio reúne todas las actividades del curso **Diseño Electrónico** (UPB). El curso combina una parte **teórica sobre inteligencia artificial** y una parte **práctica sobre IoT, sistemas embebidos y diseño electrónico**: firmware para ESP32, servidores MQTT, dashboards y diseño de PCB en KiCad.

**Autor:** Gildardo Estevan Restrepo Duque

## Actividades

| #  | Actividad                                   | Carpeta                                                | Bitácora                                                                 |
| -- | ------------------------------------------- | ------------------------------------------------------ | ------------------------------------------------------------------------ |
| 01 | Conexión a Ubidots                          | [`01_ubidots_connection`](01_ubidots_connection)       | [01_ubidots_connection.md](_docs/01_ubidots_connection.md)               |
| 02 | Suscripción a Ubidots (downlinks)           | [`02_ubidots_subscription`](02_ubidots_subscription)   | [02_ubidots_subscription.md](_docs/02_ubidots_subscription.md)           |
| 03 | Access Point + servidor web                 | [`03_webserver_accesspoint`](03_webserver_accesspoint) | [03_webserver_accesspoint.md](_docs/03_webserver_accesspoint.md)         |
| 04 | Repositorio de entregables                  | —                                                      | [04_repositorio_entregables.md](_docs/04_repositorio_entregables.md)     |
| 05 | MQTT local: Mosquitto + Node-RED            | [`05_mqtt_local_nodered`](05_mqtt_local_nodered)       | [05_mqtt_local_nodered.md](_docs/05_mqtt_local_nodered.md)               |
| 06 | MQTT en la nube: AWS + Mosquitto + Node-RED | [`06_mqtt_in_aws`](06_mqtt_in_aws)                     | [06_mqtt_in_aws.md](_docs/06_mqtt_in_aws.md)                             |
| 08 | Introducción al flujo de trabajo en KiCad   | [`08_kicad_flow_work`](08_kicad_flow_work)             | [08_kicad_flow_work.md](_docs/08_kicad_flow_work.md)                     |
| 09 | Fuente de poder en KiCad                    | [`09_power_supply`](09_power_supply)                   | [09_power_supply.md](_docs/09_power_supply.md)                           |

Cada bitácora de [`_docs/`](_docs) explica el objetivo, el montaje y cómo reproducir la práctica. Los valores reales de Wi-Fi, tokens y contraseñas no se versionan: cada proyecto trae un archivo de ejemplo (`secrets.h.example`) o marcadores para completar localmente.

La carpeta [`.claude/skills/kicad-flow`](.claude/skills/kicad-flow) contiene el flujo de trabajo para diseñar y verificar los proyectos de KiCad con Claude Code.

## Licencia

MIT. Ver [LICENSE](LICENSE).

---
## Enlaces
[[diseno_electronico_iot|Diseño Electrónico IoT]]
