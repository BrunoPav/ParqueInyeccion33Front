# Taller Mecánico — Frontend

Interfaz en Flutter para la API de historial de un taller mecánico. Compila para **web** y **Android**
desde la misma base de código.

Backend: https://github.com/BrunoPav/ParqueInyeccion33 — desplegado en https://parqueinyeccion33.onrender.com

## Qué hace

Navegación en tres niveles, siguiendo la jerarquía del modelo de datos:

```
Clientes  →  Vehículos del cliente  →  Historial de servicios del vehículo
```

Cubre las tres entidades por completo: listar, crear, editar, y dar de baja (lógica en clientes,
física en vehículos y servicios, igual que la API).

## Stack

- **Flutter 3.41** / Dart 3.11
- **Riverpod** para estado y cacheo de las respuestas de la API
- **http** para las peticiones
- Material 3

## Estructura

El proyecto está en medio de una migración a design-system + arquitectura por feature
(`dominio/datos/presentacion`), documentada paso a paso en [ROADMAP.md](ROADMAP.md). La estructura
detallada de este README se actualiza en la fase de pulido (F10) del roadmap, cuando la migración
termina; hasta entonces, ROADMAP.md es la referencia viva de qué existe y qué está en camino.

## Correr el proyecto

Contra el backend desplegado (no requiere levantar nada):

```bash
flutter run -d chrome
```

Contra un backend local:

```bash
flutter run -d chrome --dart-define=API_URL=http://localhost:8080
```

Tests y análisis estático:

```bash
flutter test
flutter analyze
```

## Notas

- Los errores de la API se muestran tal cual los devuelve el backend: el mensaje de una validación
  fallida o de un conflicto de patente duplicada llega directo a la pantalla.
- La app no repite las reglas de negocio del backend; solo valida el formato de los campos para
  evitar peticiones obviamente inválidas.
