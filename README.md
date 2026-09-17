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

```
lib/
├── main.dart
├── app/                        MaterialApp.router + tema + ThemeMode
├── core/
│   ├── config/                 entorno (URL de la API, etc.)
│   ├── design_system/
│   │   ├── tokens/              paleta · tipografia · espaciado · radios · elevacion · duraciones · dimensiones
│   │   ├── extensiones/         ThemeExtension (ColoresEstado, EspaciadoTema, ElevacionTema) + ContextoTema
│   │   ├── temas/                tema_precision (claro/oscuro) · catalogo_temas · esquemas_color · temas/componentes/
│   │   └── design_system.dart    barrel — todo lo de arriba se importa desde acá
│   ├── layout/                  puntos_corte · ContextoLayout · AndamioAdaptativo · PanelMaestroDetalle · GrillaAdaptativa
│   ├── routing/                 rutas · destinos · router (GoRouter) · resolver_por_id
│   ├── red/                     cliente_http · excepciones (ExcepcionApi, ExcepcionConexion)
│   └── utilidades/               formatos · validadores
├── shared/
│   ├── widgets/                  botones/ · entradas/ · superficies/ · retroalimentacion/ · indicadores/ · navegacion/
│   ├── dialogos/                 dialogoConfirmacion()
│   └── shared.dart               barrel
└── features/{clientes,vehiculos,servicios,ajustes}/
    ├── dominio/                  entidad + interfaz RepositorioX
    ├── datos/                    DTO · fuente remota · implementación HTTP del repositorio
    └── presentacion/
        ├── proveedores/          providers de Riverpod de la feature
        ├── pantallas/
        └── widgets/

test/
├── ayudas/                      bombear_pantalla · dobles (fakes compartidos de repositorio)
├── core/                        design_system, layout, routing
└── features/                    un archivo de test por pantalla/formulario, con fakes propios cuando
                                  el comportamiento a probar lo requiere (ver dobles en cada archivo)

docs/
├── plantilla_feature/            esqueleto copiable de una feature nueva (dominio/datos/presentacion)
└── COMO_AGREGAR_FEATURE.md       guía paso a paso para usar la plantilla
```

La reestructura a features y el design-system tokenizado están completos — el detalle de cómo se llegó
hasta acá, fase por fase, queda documentado en [ROADMAP.md](ROADMAP.md).

## Design system

Regla dura, verificada a mano en cada fase: ninguna pantalla ni widget de `features/` instancia un
`Color`, un tamaño ni un radio directo. Todo sale de un token en `core/design_system/tokens/` o de una
`ThemeExtension` expuesta vía `context.colores` / `context.espaciado` / `context.estados` /
`context.elevacion` / `context.textos` (`ContextoTema`, en
[contexto_tema.dart](lib/core/design_system/extensiones/contexto_tema.dart)).

- **Agregar/tocar un tema:** los colores de marca viven en `core/design_system/tokens/paleta.dart`
  (clases `Paleta` → `PaletaPrecisionClara` / `PaletaPrecisionOscura`). `temas/tema_precision.dart`
  arma el `ThemeData` (claro y oscuro) a partir de una `Paleta`; `temas/catalogo_temas.dart` es el
  `Map<IdTema, ThemeData Function(Brightness)>` que alimenta el selector de tema de Ajustes. Un tema
  nuevo es: una clase `Paleta` nueva + una entrada en el catálogo.
- **Agregar un componente compartido:** vive en `shared/widgets/<categoría>/`, se construye solo con
  tokens (nunca con literales), y se exporta desde `shared/shared.dart`. `core/design_system/galeria_tokens.dart`
  es una pantalla de referencia visual de los tokens y componentes base — útil para ver el catálogo
  completo sin recorrer las 6 pantallas reales.
- **Agregar una feature nueva:** seguir `docs/COMO_AGREGAR_FEATURE.md`, que usa el esqueleto de
  `docs/plantilla_feature/` como punto de partida para las 3 capas (`dominio/datos/presentacion`).

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
