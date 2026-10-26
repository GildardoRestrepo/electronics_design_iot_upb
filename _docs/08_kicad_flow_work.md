---
type: referencia
---

# Práctica #8: Introducción al flujo de trabajo de PCB de KiCAD

**Fecha:** 24/10/2026
**Estudiante:** Gildardo Estevan Restrepo Duque
**Guía:** Introducción al flujo de trabajo de PCB de KiCAD — Prof. Fabio Guzmán, UPB

---
## Introducción al flujo de kicad

### Esquemático en Eeschema
```mermaid
graph LR
	A[Setup]-->B[Symbols]-->C[Arrange, Annotate, Associate]-->D[Wire]
	D-->E[Nets]
	E-->F[Electrical Rules Check]-->G[Comments]-->H[Layout Design]

```

---

### Layout en Pcbnew
```mermaid
graph LR
A[Setup]-->B[Outline and constrains]-->C[Footprints]-->D[Route]-->E[Silkscreen]
E-->F[Design Rules Check]-->G[Export & Manufacture]
```

---
## Enlaces
[[diseno_electronico_iot|Diseño Electrónico IoT]]
