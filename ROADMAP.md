# Roadmap — Rediseño visual y arquitectura escalable

Plan de ejecución para llevar la app de "funciona" a "se ve como los mockups y aguanta crecer".

---

## Objetivo

| Meta | Cómo se logra acá |
|---|---|
| Verse consistente con los mockups (Android y web) | Design-system tokenizado en `/core`, aplicado por `ThemeData` |
| Theming escalable | Tokens → `ThemeData` claro/oscuro → catálogo de temas intercambiables |
| Responsive / adaptativo | Un solo código Flutter, tres breakpoints, andamio adaptativo |
| Extensibilidad | Features en `dominio/datos/presentacion` + plantilla copiable |
| Cero código repetido | Capa `/shared` construida sobre el design-system |

**Estado de partida:** 18 archivos Dart, 3 entidades (Cliente → Vehículo → Servicio), 6 pantallas,
Material 3 con un `seedColor` azul, sin modo oscuro, sin responsive, navegación imperativa.

---

## Cómo leer este documento

Cada paso es un `[ ]` con **qué hace**, **qué toca** y **criterio de hecho**. Las marcas indican dependencias:

| Marca | Significado |
|---|---|
| 🔓 | **Independiente** — se puede hacer en cualquier orden dentro de su fase, o en paralelo con otros 🔓 |
| 🔒 | **Bloqueante** — hay pasos o fases que no arrancan hasta que este esté hecho |
| ⛔ | **Gateado** — esperando input externo, no se puede completar todavía |

### Estado de la paleta

> **✅ Resuelto contra `mockups/*.png` (6 capturas de Stitch, Android + web).**
> DESIGN.md traía dos paletas incompatibles (frontmatter Material 3 tonal vs. prosa Tailwind slate) y
> **ninguna de las dos coincide con las capturas reales**: el fondo de los mockups es un cálido crema/rosado,
> no el gris neutro del frontmatter ni el azulado frío de la prosa. Los hex de F1.1 salen de las imágenes,
> leídos a ojo (sin color-picker en este entorno) y aceptados como aproximación de partida — se ajustan sobre
> la marcha si algo no cierra al implementar. Ver la paleta derivada en F1.1.
>
> **Hallazgo adicional que sí queda abierto:** los mockups muestran un producto bastante más grande que las
> 3 entidades actuales (Órdenes de Trabajo, Inventario, roles, notas internas, campos enriquecidos de
> Cliente/Vehículo). Confirmado contra el backend (`Cliente`/`Vehiculo`/`Servicio` son las únicas 3
> `@Entity`): nada de eso existe. Decisión tomada: **reskin puro** — F9 usa de los mockups solo lo que
> mapea a datos reales; todo lo demás queda registrado, sin construirse, en
> [Backlog — fuera de este roadmap](#backlog--fuera-de-este-roadmap).

### Decisiones ya tomadas

- **Alcance:** solo se rediseña lo que existe. 3 entidades, 6 pantallas, sin cambios de backend.
  Los componentes del mockup sin respaldo de datos (chip de estado, checklist MPI, mecánico asignado)
  se construyen igual en `/shared` como piezas listas, sin consumidor todavía.
- **Modo oscuro:** derivado de los tokens claros, presentado para aprobación antes de cablearse.
- **Nombres de capa:** en español (`dominio` / `datos` / `presentacion`), coherente con el resto del código.

### Convenciones que rigen toda la ejecución

1. **Cero comentarios inline (`//`) en Dart.** Solo `///` sobre la API pública de `core/` y `shared/`,
   que es el contrato del design-system. El código actual ya está limpio; se mantiene así.
2. **Ningún valor literal de diseño fuera de `core/design_system/`.** Nada de `Color(0x…)`,
   `EdgeInsets.all(n)`, `SizedBox(height: n)`, `BorderRadius.circular(n)` ni `TextStyle(fontSize: n)`
   en `features/` ni en `shared/`.
3. **Cada fase cierra con `flutter analyze` y `flutter test` en verde.** El CI
   ([desplegar.yml](.github/workflows/desplegar.yml)) corre ambos y **despliega a GitHub Pages en cada
   push a `main`** — un árbol roto es un despliegue roto.
4. **Cada componente de `/shared` nace con golden test** en claro y oscuro.
5. **Una rama por fase.** Merge a `main` solo con el build web verificado.

---

## Mapa de dependencias

```
F0 Preparación
     │
     ▼
F1 Tokens ──🔒──► F2 Temas ──🔒──► F3 Cableado
                     │
                     └──🔒──► F4 Componentes compartidos
                                        │
F5 Reestructura a features ──🔒──► F6 go_router ──🔒──► F7 Responsive
                                        │                     │
                                        └─────────┬───────────┘
                                                  ▼
                                        F8 Plantilla de feature
                                                  │
                                                  ▼
                                        F9 Rediseño de pantallas
                                                  │
                                                  ▼
                                        F10 Pulido y verificación
```

**Se pueden hacer en paralelo:** F4 (componentes) y F5 (reestructura) no se tocan entre sí — una vive en
`shared/`, la otra en `features/`. F8 (plantilla) solo necesita que F5 esté hecha, no F6/F7.

---

# F0 · Preparación y red de seguridad

> Dejar el terreno listo y, sobre todo, **desacoplar el test del árbol de widgets** antes de tocar nada.
> Hoy `test/widget_test.dart` monta `AplicacionTaller` completo y busca textos literales: el primer cambio
> de tema o de routing rompe el CI, que despliega a producción.

- [x] **F0.1** 🔓 Agregar `go_router` a las dependencias.
  **Toca:** `pubspec.yaml`.
  **Hecho:** `flutter pub get` sin conflictos y `pubspec.lock` actualizado.

- [x] **F0.2** 🔓 Agregar `shared_preferences` para persistir la elección de tema.
  **Toca:** `pubspec.yaml`.
  **Hecho:** `flutter pub get` limpio; compila en web y Android.

- [x] **F0.3** 🔓 Descargar los pesos estáticos de **Inter** (400/500/600/700) y **JetBrains Mono**
  (400/500/700) a `assets/fuentes/`.
  **Toca:** `assets/fuentes/` (nuevo).
  **Hecho:** 7 `.ttf` en disco, nombrados `Inter-Regular.ttf`, `Inter-Medium.ttf`, `Inter-SemiBold.ttf`,
  `Inter-Bold.ttf`, `JetBrainsMono-Regular.ttf`, `JetBrainsMono-Medium.ttf`, `JetBrainsMono-Bold.ttf`.
  *Se eligen pesos estáticos y no la variable font: declaración más simple y soporte universal en web y Android.*

- [x] **F0.4** 🔒 Declarar las dos familias en la sección `flutter:` del pubspec.
  **Toca:** `pubspec.yaml`.
  **Hecho:** un `Text` de prueba con `fontFamily: 'Inter'` renderiza con Inter, no con Roboto.
  *Bloquea F1.2.*

- [x] **F0.5** 🔓 Endurecer el analizador: `prefer_const_constructors`,
  `prefer_const_constructors_in_immutables`, `require_trailing_commas`,
  `avoid_redundant_argument_values`, `unnecessary_parenthesis`, `sort_child_properties_last`,
  `use_super_parameters`, `directives_ordering`.
  **Toca:** `analysis_options.yaml`.
  **Hecho:** `flutter analyze` corre y el listado de issues resultante queda anotado en el PR.

- [x] **F0.6** 🔓 Corregir todo lo que las reglas nuevas señalen en el código actual.
  **Toca:** los 18 archivos de `lib/`.
  **Hecho:** `flutter analyze` sin issues.

- [x] **F0.7** 🔓 Borrar los comentarios boilerplate de `flutter create` en `pubspec.yaml`
  (las ~35 líneas de `# The following defines…`, `# To add assets…`, `# To add custom fonts…`).
  **Toca:** `pubspec.yaml`.
  **Hecho:** el archivo solo contiene declaraciones reales; se conserva únicamente el `# publish_to` si aporta.

- [x] **F0.8** 🔓 Borrar los comentarios boilerplate de `analysis_options.yaml` (las ~20 líneas explicativas
  y los dos ejemplos comentados de reglas).
  **Toca:** `analysis_options.yaml`.
  **Hecho:** el archivo es solo `include:` + `linter: rules:` con las reglas activas.

- [x] **F0.9** 🔓 Reemplazar los textos placeholder en `pubspec.yaml`:
  `description: "A new Flutter project."` por la descripción real del proyecto.
  **Toca:** `pubspec.yaml`.
  **Hecho:** ningún string generado por `flutter create` sobrevive en el archivo.

- [x] **F0.10** 🔓 Limpiar `web/index.html`: sacar los tres bloques de comentario de plantilla, poner
  `<title>` y `<meta name="description">` reales, y `apple-mobile-web-app-title` legible
  (hoy dice `taller_mecanico_frontend`).
  **Toca:** `web/index.html`.
  **Hecho:** la pestaña del navegador muestra el nombre real de la app.

- [x] **F0.11** 🔓 Actualizar `name`, `short_name` y `description` en el manifest.
  **Toca:** `web/manifest.json`.
  **Hecho:** el nombre real aparece al instalar la PWA.

- [x] **F0.12** 🔒 Crear `test/ayudas/bombear_pantalla.dart`: helper que monta **una pantalla**
  dentro de `ProviderScope` + `MaterialApp` con el tema real, aceptando `overrides`.
  **Toca:** `test/ayudas/bombear_pantalla.dart` (nuevo).
  **Hecho:** el helper compila y expone `Future<void> bombearPantalla(WidgetTester, Widget, {List<Override>})`.
  *Bloquea F0.13. Es el paso que protege al CI durante las 10 fases siguientes.*

- [x] **F0.13** 🔒 Reescribir los dos tests de `widget_test.dart` sobre el helper: montar
  `PantallaClientes` directamente en vez de `AplicacionTaller`, conservando los `ApiClienteFalso` /
  `_ApiVacia` que ya existen.
  **Toca:** `test/widget_test.dart` → `test/features/clientes/pantalla_clientes_test.dart`.
  **Hecho:** `flutter test` verde y **ningún test importa `main.dart`**.

- [x] **F0.14** 🔓 Crear `test/ayudas/dobles.dart` y mover ahí `ApiClienteFalso` y `_ApiVacia` para poder
  reusarlos en las fases siguientes.
  **Toca:** `test/ayudas/dobles.dart` (nuevo), `test/features/clientes/pantalla_clientes_test.dart`.
  **Hecho:** los dobles se importan, no se redefinen.

- [x] **F0.15** 🔓 Fijar el `flutter-version` del workflow al mismo que usa el entorno local.
  **Toca:** `.github/workflows/desplegar.yml`.
  **Hecho:** `flutter --version` local y el del workflow coinciden.

- [x] **F0.16** 🔓 Renombrar `DESING.md` → `DESIGN.md` (typo) y actualizar cualquier referencia.
  **Toca:** `DESIGN.md`, `README.md`, este archivo.
  **Hecho:** ya renombrado por el usuario. Pendiente: confirmar que no queda ninguna referencia colgada
  al nombre viejo fuera de este documento.

- [x] **F0.17** 🔓 Reconciliar la sección "Estructura" del README, que hoy describe la estructura vieja.
  **Toca:** `README.md`.
  **Hecho:** nota apuntando a este roadmap; el árbol detallado se actualiza en F10.

- [x] **F0.18** ✅ **Cierre de fase:** `flutter analyze` sin issues, `flutter test` verde,
  `flutter build web --release` exitoso.

---

# F1 · Tokens del design-system

> Los valores crudos, en un solo lugar, sin dependencia de Flutter salvo `dart:ui`.
> **Ninguna pantalla se toca en esta fase.** Al terminar, la app se ve exactamente igual.

- [ ] **F1.1** 🔒 **Paleta.** Definir `abstract class Paleta` con los slots del design-system e
  implementar `PaletaPrecisionClara` con los valores derivados de `mockups/*.png`:

  | Slot | Hex aprox. | Leído en |
  |---|---|---|
  | `fondo` (canvas) | `#FBF3F0` crema rosado | Todas las pantallas |
  | `superficie` (tarjetas) | `#FFFFFF` | Tarjetas de cliente/vehículo/servicio |
  | `bordeSuperficie` | `#F0DED8` rosado suave | Borde 1px de tarjeta |
  | `primario` (negro cálido) | `#191512` | Botones "+ Nuevo…", "Iniciar Recepción" |
  | `onPrimario` | `#FFFFFF` | Texto sobre primario |
  | `secundario` / acento (terracota) | `#C4501B` | Íconos, links, "Último servicio", patente |
  | `onSecundarioSuave` | fondo `#F7E4DA` / texto `#8A3814` | Chip "En taller actualmente" |
  | `textoPrincipal` | `#1C1512` | Títulos, nombres |
  | `textoSecundario` | `#6B5B54` | Subtítulos, metadatos |
  | `estadoExitoFondo` / `Texto` | `#DCFCE7` / `#15803D` | Chip "Service al día" |
  | `estadoAlertaFondo` / `Texto` | `#FDE4D5` / `#C2410C` | Chip "Distribución pendiente" |

  **Toca:** `lib/core/design_system/tokens/paleta.dart` (nuevo).
  **Hecho:** todos los slots del design-system poblados (no solo los leídos arriba — el resto se deriva
  manteniendo la misma temperatura cálida). Valores marcados `///` como **aproximados de mockup**, no
  muestreados a pixel; se recalibran si al implementar algún contraste no cierra.

- [ ] **F1.2** 🔒 **Tipografía — familias y features.** Constantes de familia (`Inter`, `JetBrains Mono`)
  y el `FontFeature.tabularFigures()` que el design-system exige para odómetros, horas y montos.
  **Toca:** `lib/core/design_system/tokens/tipografia.dart` (nuevo).
  **Hecho:** las constantes resuelven a las fuentes declaradas en F0.4.
  *Depende de F0.4.*

- [ ] **F1.3** 🔒 **Tipografía — escala.** La escala completa como `TextStyle` sin color
  (el color lo pone el tema). Único valor especificado en DESIGN.md: `headline-lg` = Inter 32/40, w700, -0.02em.
  El resto (`title-lg`, `title-md`, `body-lg`, `body-md`, `body-sm`, `label-lg`, `label-md`, `label-sm`)
  **se deriva** y se marca como derivado en un `///` sobre la clase.
  **Toca:** `lib/core/design_system/tokens/tipografia.dart`.
  **Hecho:** `headline-lg` coincide exacto con DESIGN.md; los derivados quedan anotados para revisión.

- [ ] **F1.4** 🔓 **Tipografía — mono.** `labelMono`: JetBrains Mono, mayúsculas, tracking abierto,
  para patentes y VIN. El design-system lo pide explícitamente para eliminar la ambigüedad `0`/`O`, `1`/`I`.
  **Toca:** `lib/core/design_system/tokens/tipografia.dart`.
  **Hecho:** una patente renderizada con `labelMono` distingue visualmente `0` de `O`.

- [ ] **F1.5** 🔒 **Espaciado.** Los 12 valores del frontmatter, sin reinterpretar:
  `xxs 4 · xs 8 · sm 12 · md 16 · lg 20 · xl 24 · xxl 32`, `bordePantallaMovil 16`,
  `bordePantallaTablet 24`, `separacionLista 12`, `objetivoTactil 48`, `objetivoTactilAmplio 56`.
  **Toca:** `lib/core/design_system/tokens/espaciado.dart` (nuevo).
  **Hecho:** cada constante coincide 1:1 con el frontmatter de DESIGN.md.

- [ ] **F1.6** 🔓 **Espaciado — helpers.** `EdgeInsets` predefinidos de uso frecuente
  (padding de tarjeta 16, borde de pantalla por breakpoint, padding de chip `4px 10px`).
  **Toca:** `lib/core/design_system/tokens/espaciado.dart`.
  **Hecho:** cubren los casos que hoy aparecen literales en las 6 pantallas.

- [ ] **F1.7** 🔒 **Radios.** `xs 2 · sm 4 · md 6 · lg 8 · xl 12 · completo 9999`, más los alias semánticos
  que fija la prosa: `chip = sm (4)`, `tarjeta = lg (8)`, `boton = lg (8)`, `entrada = lg (8)`,
  `contenedor = xl (12)`.
  **Toca:** `lib/core/design_system/tokens/radios.dart` (nuevo).
  **Hecho:** los alias existen; las pantallas usarán los alias, nunca los números.

- [ ] **F1.8** 🔒 **Elevación.** Los 3 niveles como estructura `(colorBorde, anchoBorde, List<BoxShadow>)`,
  **no** como `elevation:` numérico de Material: el design-system pide capa tonal + borde 1px crisp,
  y rechaza explícitamente la sombra difusa.
  **Toca:** `lib/core/design_system/tokens/elevacion.dart` (nuevo).
  **Hecho:** N1 (tarjetas), N2 (activo/modales) y N3 (barra inferior, sombra hacia arriba) definidos.

- [ ] **F1.9** 🔓 **Duraciones y curvas.** Tokens de animación para transiciones de ruta y cambios de estado.
  **Toca:** `lib/core/design_system/tokens/duraciones.dart` (nuevo).
  **Hecho:** `rapida` / `normal` / `lenta` + curvas estándar definidas.

- [ ] **F1.10** 🔓 **Tamaños de componente.** Las alturas que fija la prosa:
  `botonPrimario 52`, `botonSecundario 48`, `entrada 48`, `chip 28`, `filaLista 56`, `anchoBordeEntrada 1.5`.
  **Toca:** `lib/core/design_system/tokens/dimensiones.dart` (nuevo).
  **Hecho:** ningún widget de `/shared` tendrá que escribir una altura a mano.

- [ ] **F1.11** 🔒 **Barrel de tokens.** Un solo import para toda la capa.
  **Toca:** `lib/core/design_system/tokens/tokens.dart` (nuevo).
  **Hecho:** `import 'tokens/tokens.dart'` alcanza para acceder a todos.

- [ ] **F1.12** 🔒 **Paleta oscura.** Ningún mockup trae versión oscura — se deriva de
  `PaletaPrecisionClara`: invertir las capas tonales conservando la jerarquía de superficies, mantener el
  terracota como acento de alerta (es el color que no puede perder saliencia en un taller a oscuras), y
  verificar contraste.
  **Toca:** `lib/core/design_system/tokens/paleta.dart`.
  **Hecho:** **presentada al usuario para aprobación** antes de cablearla (no se asume); todos los pares
  texto/fondo pasan WCAG AA (4.5:1 texto normal, 3:1 texto grande).

- [ ] **F1.13** 🔓 Test de tokens: verificar que la escala de espaciado es monótona creciente y que los
  radios semánticos apuntan a los valores esperados.
  **Toca:** `test/core/design_system/tokens_test.dart` (nuevo).
  **Hecho:** `flutter test` verde. Barato, pero atrapa el typo que después cuesta media hora.

- [ ] **F1.14** 🔓 Test de contraste: recorrer los pares (fondo, textoEncima) de ambas paletas y afirmar
  el ratio mínimo.
  **Toca:** `test/core/design_system/contraste_test.dart` (nuevo).
  **Hecho:** ambas paletas pasan; el test falla ruidosamente si alguien mete un color sin chequear.

- [ ] **F1.15** ✅ **Cierre de fase:** `flutter analyze` + `flutter test` verdes. **La app se ve idéntica**
  — nada consume los tokens todavía. Es la señal de que la fase se hizo bien.

---

# F2 · ThemeData claro/oscuro + catálogo multi-tema

> Convertir tokens en `ThemeData`. Acá se decide qué va en `ColorScheme` (lo que Material entiende)
> y qué va en `ThemeExtension` (lo que Material no tiene dónde guardar).
> **Depende de F1. Bloquea F3 y F4.**

- [ ] **F2.1** 🔒 Mapear `PaletaPrecisionClara` → `ColorScheme` claro completo.
  **Toca:** `lib/core/design_system/temas/esquemas_color.dart` (nuevo).
  **Hecho:** los 30+ slots poblados; ninguno queda en el default de Flutter.

- [ ] **F2.2** 🔒 Mapear `PaletaPrecisionOscura` → `ColorScheme` oscuro completo.
  **Toca:** `lib/core/design_system/temas/esquemas_color.dart`.
  **Hecho:** ídem, con `brightness: Brightness.dark`.

- [ ] **F2.3** 🔒 **`ColoresEstado extends ThemeExtension<ColoresEstado>`** — los 5 estados semánticos
  (listo, enCurso, pendiente, critico, archivado), cada uno con `{fondo, borde, texto}`.
  `ColorScheme` no tiene slots para esto y son el corazón de la lectura rápida en el taller.
  **Toca:** `lib/core/design_system/extensiones/colores_estado.dart` (nuevo).
  **Hecho:** `copyWith` y `lerp` implementados (si no, la transición de tema parpadea); instancias clara y oscura.

- [ ] **F2.4** 🔒 **`EspaciadoTema extends ThemeExtension<EspaciadoTema>`** — expone la escala vía tema,
  para que un widget nunca importe el token directo.
  **Toca:** `lib/core/design_system/extensiones/espaciado_tema.dart` (nuevo).
  **Hecho:** `copyWith` y `lerp` implementados.

- [ ] **F2.5** 🔒 **`ElevacionTema extends ThemeExtension<ElevacionTema>`** — los 3 niveles resueltos
  por brillo (las sombras y bordes del modo oscuro no son los del claro).
  **Toca:** `lib/core/design_system/extensiones/elevacion_tema.dart` (nuevo).
  **Hecho:** `copyWith` y `lerp` implementados; N1/N2/N3 distintos entre claro y oscuro.

- [ ] **F2.6** 🔒 **`extension ContextoTema on BuildContext`** — `context.colores`, `context.textos`,
  `context.espaciado`, `context.estados`, `context.elevacion`.
  **Toca:** `lib/core/design_system/extensiones/contexto_tema.dart` (nuevo).
  **Hecho:** `context.espaciado.md` compila y devuelve 16. Es la API que van a usar las 6 pantallas.

- [ ] **F2.7** 🔒 Construir el `TextTheme` completo desde la escala de F1.3.
  **Toca:** `lib/core/design_system/temas/tema_precision.dart` (nuevo).
  **Hecho:** los 15 slots de `TextTheme` mapeados; `Theme.of(context).textTheme.titleMedium` da Inter.

- [ ] **F2.8** 🔓 `FilledButtonThemeData` + `ElevatedButtonThemeData`: altura 52, radio 8, tipografía
  `label-lg`, estado presionado atenuado.
  **Toca:** `lib/core/design_system/temas/componentes/tema_botones.dart` (nuevo).
  **Hecho:** un `FilledButton` sin envolver ya sale con el look correcto.

- [ ] **F2.9** 🔓 `OutlinedButtonThemeData` + `TextButtonThemeData`: altura 48, borde 1px, radio 8.
  **Toca:** `lib/core/design_system/temas/componentes/tema_botones.dart`.
  **Hecho:** ídem para las variantes secundarias.

- [ ] **F2.10** 🔓 `InputDecorationTheme`: altura 48, borde **1.5px**, radio 8, foco con borde primario +
  anillo concéntrico 2px, estilos de error y de `helperText`.
  **Toca:** `lib/core/design_system/temas/componentes/tema_entradas.dart` (nuevo).
  **Hecho:** los `TextFormField` actuales pierden su `OutlineInputBorder` literal y heredan el tema.
  *Este solo paso limpia 8 declaraciones repetidas de `border: OutlineInputBorder()` en los 3 formularios.*

- [ ] **F2.11** 🔓 `CardThemeData`: superficie N1, borde 1px, radio 8, sombra del token, `margin` cero.
  **Toca:** `lib/core/design_system/temas/componentes/tema_superficies.dart` (nuevo).
  **Hecho:** un `Card` pelado se ve como la tarjeta del mockup.

- [ ] **F2.12** 🔓 `ChipThemeData` + `FilterChipThemeData`: altura 28, padding `4px 10px`, radio 4,
  `label-md` en mayúsculas.
  **Toca:** `lib/core/design_system/temas/componentes/tema_indicadores.dart` (nuevo).
  **Hecho:** los `FilterChip` de Activos/Inactivos en [pantalla_clientes.dart:100](lib/pantallas/pantalla_clientes.dart#L100)
  se ven correctos sin tocarlos.

- [ ] **F2.13** 🔓 `AppBarTheme`: sin sombra, borde inferior 1px, título con la tipografía correcta,
  altura acorde al mockup.
  **Toca:** `lib/core/design_system/temas/componentes/tema_navegacion.dart` (nuevo).
  **Hecho:** la barra superior no proyecta la sombra difusa de Material.

- [ ] **F2.14** 🔓 `NavigationBarThemeData` + `NavigationRailThemeData` (los consume F7, se definen acá
  para no fragmentar el tema).
  **Toca:** `lib/core/design_system/temas/componentes/tema_navegacion.dart`.
  **Hecho:** ambos definidos y coherentes entre sí.

- [ ] **F2.15** 🔓 `DividerThemeData`, `ListTileThemeData`, `SnackBarThemeData`, `DialogThemeData`,
  `PopupMenuThemeData`, `FloatingActionButtonThemeData`.
  **Toca:** `lib/core/design_system/temas/componentes/tema_varios.dart` (nuevo).
  **Hecho:** ningún widget Material queda con estilo de fábrica.

- [ ] **F2.16** 🔒 Ensamblar `ThemeData temaPrecision(Brightness)` combinando esquema + `TextTheme` +
  sub-temas + las 3 `ThemeExtension`.
  **Toca:** `lib/core/design_system/temas/tema_precision.dart`.
  **Hecho:** devuelve un `ThemeData` completo para cada brillo con `useMaterial3: true`.

- [ ] **F2.17** 🔒 **Catálogo de temas.** `enum IdTema` + `typedef ConstructorTema = ThemeData Function(Brightness)`
  + `const Map<IdTema, ConstructorTema> catalogoTemas`.
  **Toca:** `lib/core/design_system/temas/catalogo_temas.dart` (nuevo).
  **Hecho:** sumar un tema nuevo = agregar una paleta + una entrada al mapa. Nada más.
  *Esta es la pieza que cumple el objetivo de "múltiples temas intercambiables".*

- [ ] **F2.18** 🔓 Barrel del design-system: un import para tokens + extensiones + temas.
  **Toca:** `lib/core/design_system/design_system.dart` (nuevo).
  **Hecho:** `import 'core/design_system/design_system.dart'` alcanza.

- [ ] **F2.19** 🔓 Test: `temaPrecision(Brightness.light)` y `(dark)` traen las 3 `ThemeExtension`
  y ninguna es `null`.
  **Toca:** `test/core/design_system/tema_test.dart` (nuevo).
  **Hecho:** verde. Atrapa la extensión que alguien agrega y se olvida de registrar.

- [ ] **F2.20** 🔓 Test: `lerp` al 50% entre el tema claro y el oscuro no lanza ni devuelve `null`
  en ninguna extensión.
  **Toca:** `test/core/design_system/tema_test.dart`.
  **Hecho:** verde — garantiza que la transición de tema no parpadea.

- [ ] **F2.21** 🔓 Crear una galería de tokens: pantalla de debug que renderiza la escala tipográfica,
  la paleta, los espaciados, los radios y los 3 niveles de elevación.
  **Toca:** `lib/core/design_system/galeria_tokens.dart` (nuevo, solo debug).
  **Hecho:** se puede abrir y comparar contra los mockups lado a lado.
  *Vale muchísimo en F9: es la referencia visual sin salir de la app.*

- [ ] **F2.22** ✅ **Cierre de fase:** analyze + test verdes; la app **sigue viéndose igual**
  (nadie consume el tema todavía).

---

# F3 · Cableado del tema en la app

> Enchufar el tema y hacerlo conmutable. Sin esta fase, el modo oscuro no se puede probar de verdad.
> **Depende de F2.**

- [ ] **F3.1** 🔒 Crear `lib/app/aplicacion.dart` y mover ahí `AplicacionTaller` desde `main.dart`.
  **Toca:** `lib/app/aplicacion.dart` (nuevo), `lib/main.dart`.
  **Hecho:** `main.dart` queda solo con `runApp`.

- [ ] **F3.2** 🔒 `AplicacionTaller` pasa a `ConsumerWidget` y recibe `theme`, `darkTheme` y `themeMode`
  desde providers.
  **Toca:** `lib/app/aplicacion.dart`.
  **Hecho:** el `seedColor` azul de [main.dart:19](lib/main.dart#L19) desaparece del código.

- [ ] **F3.3** 🔒 `preferenciasProvider`: `shared_preferences` expuesto por Riverpod, inicializado
  con `overrideWithValue` en `main.dart` tras el `await`.
  **Toca:** `lib/features/ajustes/datos/preferencias.dart` (nuevo), `lib/main.dart`.
  **Hecho:** se lee sin `await` desde los widgets.

- [ ] **F3.4** 🔒 `modoTemaProvider` — `Notifier<ThemeMode>` que lee y escribe la preferencia.
  **Toca:** `lib/features/ajustes/presentacion/proveedores/tema_proveedores.dart` (nuevo).
  **Hecho:** cambiar el modo persiste y sobrevive al reinicio.

- [ ] **F3.5** 🔓 `temaSeleccionadoProvider` — `Notifier<IdTema>` contra el catálogo de F2.17.
  **Toca:** `lib/features/ajustes/presentacion/proveedores/tema_proveedores.dart`.
  **Hecho:** cambiar el id reconstruye la app con el tema nuevo.

- [ ] **F3.6** 🔓 Pantalla de ajustes con selector de modo (claro / oscuro / sistema).
  **Toca:** `lib/features/ajustes/presentacion/pantallas/pantalla_ajustes.dart` (nuevo).
  **Hecho:** los tres modos funcionan y se ven correctos.

- [ ] **F3.7** 🔓 Agregar el selector de tema a la misma pantalla (aunque el catálogo tenga un solo tema:
  deja el camino probado).
  **Toca:** `lib/features/ajustes/presentacion/pantallas/pantalla_ajustes.dart`.
  **Hecho:** el selector lista el catálogo y aplicar uno funciona.

- [ ] **F3.8** 🔓 Acceso temporal a ajustes desde el `AppBar` de clientes (en F7 se mueve a la navegación).
  **Toca:** `lib/pantallas/pantalla_clientes.dart`.
  **Hecho:** se llega a ajustes desde la app corriendo.

- [ ] **F3.9** 🔓 Mover `lib/config.dart` → `lib/core/config/entorno.dart`.
  **Toca:** `lib/config.dart` (borrar), `lib/core/config/entorno.dart` (nuevo), `lib/api/api_base.dart`.
  **Hecho:** `--dart-define=API_URL` sigue funcionando.

- [ ] **F3.10** 🔓 Test: alternar `modoTemaProvider` cambia el brillo del `MaterialApp`.
  **Toca:** `test/features/ajustes/tema_proveedores_test.dart` (nuevo).
  **Hecho:** verde.

- [ ] **F3.11** 🔓 Test: la preferencia persiste — escribir, reconstruir el scope, leer.
  **Toca:** `test/features/ajustes/tema_proveedores_test.dart`.
  **Hecho:** verde con el mock de `shared_preferences`.

- [ ] **F3.12** ✅ **Cierre de fase.** Acá la app **cambia de aspecto por primera vez**: las 6 pantallas
  heredan el tema nuevo sin haber sido tocadas. Recorrerlas en claro y en oscuro y anotar lo que quede feo
  — esa lista alimenta F9.

- [ ] **F3.13** 🔓 Revisar Android: barra de estado y de navegación acompañando el tema
  (`SystemUiOverlayStyle`).
  **Toca:** `lib/app/aplicacion.dart`.
  **Hecho:** en oscuro, las barras del sistema no quedan blancas.

- [ ] **F3.14** 🔓 Revisar web: `<meta name="theme-color">` y color de fondo del loader coherentes.
  **Toca:** `web/index.html`, `web/manifest.json`.
  **Hecho:** no hay flash blanco al cargar en modo oscuro.

---

# F4 · Componentes compartidos

> Acá muere la duplicación. Cada componente se construye **solo** con tokens y trae su golden test.
> **Depende de F2.** 🔓 Los grupos son independientes entre sí: se pueden repartir o hacer en cualquier orden.

### Botones

- [ ] **F4.1** 🔒 `BotonPrimario` — altura 52, ancho completo por defecto, con `cargando` interno que
  intercambia el ícono por un spinner y deshabilita el `onPressed`.
  **Toca:** `lib/shared/widgets/botones/boton_primario.dart` (nuevo).
  **Hecho:** reemplaza las **3 copias idénticas** del botón Guardar
  ([formulario_cliente.dart:112](lib/pantallas/formulario_cliente.dart#L112),
  [formulario_vehiculo.dart:185](lib/pantallas/formulario_vehiculo.dart#L185),
  [formulario_servicio.dart:160](lib/pantallas/formulario_servicio.dart#L160)).

- [ ] **F4.2** 🔓 `BotonSecundario` — altura 48, fondo tenue, borde 1px.
  **Toca:** `lib/shared/widgets/botones/boton_secundario.dart` (nuevo).
  **Hecho:** coincide con la spec de "Secondary Action" del design-system.

- [ ] **F4.3** 🔓 `BotonPeligro` — altura 48, fondo y borde de la rampa de error, para acciones destructivas.
  **Toca:** `lib/shared/widgets/botones/boton_peligro.dart` (nuevo).
  **Hecho:** coincide con la spec de "Danger / Stop Action".

- [ ] **F4.4** 🔓 `BotonIcono` — botón de ícono con área táctil garantizada de 48×48.
  **Toca:** `lib/shared/widgets/botones/boton_icono.dart` (nuevo).
  **Hecho:** el área táctil mide 48 aunque el ícono mida 20.

- [ ] **F4.5** 🔓 Goldens de los 4 botones en claro y oscuro, en reposo / presionado / deshabilitado / cargando.
  **Toca:** `test/shared/botones_golden_test.dart` (nuevo).
  **Hecho:** 32 goldens generados y versionados.

### Entradas

- [ ] **F4.6** 🔒 `CampoTexto` — envuelve `TextFormField` heredando `InputDecorationTheme`, con
  `etiqueta`, `validador`, `maxLineas`, `capitalizacion`.
  **Toca:** `lib/shared/widgets/entradas/campo_texto.dart` (nuevo).
  **Hecho:** ningún formulario vuelve a escribir `border: OutlineInputBorder()`.

- [ ] **F4.7** 🔓 `CampoNumerico` — teclado numérico forzado (el design-system lo exige para odómetro,
  SKU y cantidades), cifras tabulares, validación de rango.
  **Toca:** `lib/shared/widgets/entradas/campo_numerico.dart` (nuevo).
  **Hecho:** reemplaza a `_validarEntero` de
  [formulario_vehiculo.dart:53](lib/pantallas/formulario_vehiculo.dart#L53), que hoy vive dentro de la pantalla.

- [ ] **F4.8** 🔓 `CampoMoneda` — prefijo de moneda, decimales, acepta coma y punto.
  **Toca:** `lib/shared/widgets/entradas/campo_moneda.dart` (nuevo).
  **Hecho:** conserva la normalización `replaceAll(',', '.')` de
  [formulario_servicio.dart:70](lib/pantallas/formulario_servicio.dart#L70).

- [ ] **F4.9** 🔓 `CampoFecha` — el patrón `InkWell` + `InputDecorator` + `showDatePicker`, como componente.
  **Toca:** `lib/shared/widgets/entradas/campo_fecha.dart` (nuevo).
  **Hecho:** reemplaza el bloque de [formulario_servicio.dart:105](lib/pantallas/formulario_servicio.dart#L105).

- [ ] **F4.10** 🔓 `BarraBusqueda` — altura 48, ícono de lupa, botón de limpiar automático, debounce.
  **Toca:** `lib/shared/widgets/entradas/barra_busqueda.dart` (nuevo).
  **Hecho:** reemplaza el `TextField` inline de
  [pantalla_clientes.dart:75](lib/pantallas/pantalla_clientes.dart#L75), incluida su lógica de `suffixIcon`
  condicional. El debounce es una mejora: hoy solo busca con `onSubmitted`.

- [ ] **F4.11** 🔓 `CampoPatente` — mayúsculas forzadas, tipografía mono, largo máximo.
  **Toca:** `lib/shared/widgets/entradas/campo_patente.dart` (nuevo).
  **Hecho:** aplica la regla de desambiguación `0`/`O` del design-system en la entrada, no solo en la lectura.

- [ ] **F4.12** 🔓 Goldens de las entradas en claro y oscuro: reposo / foco / error / deshabilitado.
  **Toca:** `test/shared/entradas_golden_test.dart` (nuevo).
  **Hecho:** generados y versionados. El estado de foco (borde primario + anillo 2px) se verifica acá.

### Superficies

- [ ] **F4.13** 🔒 `TarjetaTaller` — los 3 niveles de elevación por parámetro, padding 16, radio 8,
  con `onTap` opcional y feedback de presión instantáneo.
  **Toca:** `lib/shared/widgets/superficies/tarjeta_taller.dart` (nuevo).
  **Hecho:** los 3 niveles son visualmente distinguibles en claro y oscuro.

- [ ] **F4.14** 🔓 `FilaLista` — la anatomía del mockup: fila superior (badge + chip), fila media
  (título + descripción con `line-clamp-2`), fila inferior (metadatos). Toda la tarjeta es un solo target.
  **Toca:** `lib/shared/widgets/superficies/fila_lista.dart` (nuevo).
  **Hecho:** reemplaza el patrón `ListTile` + `Divider` de las 3 pantallas de listado.

- [ ] **F4.15** 🔓 `SeccionFormulario` — agrupa campos con encabezado y el espaciado vertical correcto.
  **Toca:** `lib/shared/widgets/superficies/seccion_formulario.dart` (nuevo).
  **Hecho:** elimina los `SizedBox(height: 16)` sueltos de los 3 formularios.

- [ ] **F4.16** 🔓 `BarraInferiorAcciones` — la "Sticky Bottom Utility Bar": anclada abajo, con
  `SafeArea`, borde superior y sombra hacia arriba.
  **Toca:** `lib/shared/widgets/navegacion/barra_inferior_acciones.dart` (nuevo).
  **Hecho:** respeta el inset inferior en Android con gestos.

- [ ] **F4.17** 🔓 Goldens de superficies en claro y oscuro.
  **Toca:** `test/shared/superficies_golden_test.dart` (nuevo).
  **Hecho:** generados y versionados.

### Indicadores

- [ ] **F4.18** 🔓 `ChipEstado` — los 5 estados vía `ColoresEstado`, altura 28, padding `4px 10px`,
  radio 4, `label-md` en mayúsculas.
  **Toca:** `lib/shared/widgets/indicadores/chip_estado.dart` (nuevo).
  **Hecho:** los 5 estados renderizan con su terna fondo/borde/texto.
  *Sin consumidor hasta que el backend tenga un campo de estado — decisión de alcance tomada.*

- [ ] **F4.19** 🔓 `InsigniaPatente` — badge mono, mayúsculas, radio 4, borde 1px.
  **Toca:** `lib/shared/widgets/indicadores/insignia_patente.dart` (nuevo).
  **Hecho:** reemplaza el `Text` crudo de la patente en
  [pantalla_vehiculos.dart:111](lib/pantallas/pantalla_vehiculos.dart#L111).

- [ ] **F4.20** 🔓 `EtiquetaMetadato` — ícono + texto para las filas de pie de tarjeta.
  **Toca:** `lib/shared/widgets/indicadores/etiqueta_metadato.dart` (nuevo).
  **Hecho:** usa cifras tabulares cuando el contenido es numérico.

- [ ] **F4.21** 🔓 `FilaInspeccion` — la fila de checklist MPI: altura mínima 56, control 28×28 en el
  extremo, 4 estados (sin marcar / aprobado / atención / falla).
  **Toca:** `lib/shared/widgets/indicadores/fila_inspeccion.dart` (nuevo).
  **Hecho:** los 4 estados renderizan. *Pieza lista sin consumidor, igual que F4.18.*

- [ ] **F4.22** 🔓 `Avatar` — inicial o ícono, tamaño por token.
  **Toca:** `lib/shared/widgets/indicadores/avatar.dart` (nuevo).
  **Hecho:** reemplaza los 3 `CircleAvatar` de las pantallas de listado.

- [ ] **F4.23** 🔓 Goldens de indicadores: los 5 estados de chip y los 4 de inspección, en ambos temas.
  **Toca:** `test/shared/indicadores_golden_test.dart` (nuevo).
  **Hecho:** generados y versionados.

### Retroalimentación

- [ ] **F4.24** 🔒 Mover `VistaAsync` a `shared/` y quitarle los literales
  (`EdgeInsets.all(24)`, `size: 48`, `SizedBox(height: 16)`).
  **Toca:** `lib/widgets/vista_async.dart` → `lib/shared/widgets/retroalimentacion/vista_async.dart`.
  **Hecho:** cero valores literales; comportamiento idéntico.

- [ ] **F4.25** 🔓 Extraer `VistaError` a su propio archivo (hoy es la clase privada `_VistaError`)
  y agregarle un modo compacto para usar dentro de un panel de master-detail.
  **Toca:** `lib/shared/widgets/retroalimentacion/vista_error.dart` (nuevo).
  **Hecho:** utilizable fuera de `VistaAsync`.

- [ ] **F4.26** 🔓 Rehacer `VistaVacia` con la anatomía del mockup: ícono, título, texto de apoyo y
  acción primaria opcional.
  **Toca:** `lib/shared/widgets/retroalimentacion/vista_vacia.dart` (nuevo).
  **Hecho:** los 3 usos actuales siguen funcionando; ahora puede ofrecer "Crear el primero".

- [ ] **F4.27** 🔒 `Notificador` — **un solo punto** para los mensajes de error y éxito.
  **Toca:** `lib/shared/widgets/retroalimentacion/notificador.dart` (nuevo).
  **Hecho:** reemplaza las **6 copias textuales** del `SnackBar` de error
  ([pantalla_clientes.dart:47](lib/pantallas/pantalla_clientes.dart#L47),
  [pantalla_vehiculos.dart:67](lib/pantallas/pantalla_vehiculos.dart#L67),
  [pantalla_servicios.dart:71](lib/pantallas/pantalla_servicios.dart#L71),
  [formulario_cliente.dart:60](lib/pantallas/formulario_cliente.dart#L60),
  [formulario_vehiculo.dart:93](lib/pantallas/formulario_vehiculo.dart#L93),
  [formulario_servicio.dart:85](lib/pantallas/formulario_servicio.dart#L85)).
  *La mayor reducción de duplicación de todo el roadmap.*

- [ ] **F4.28** 🔓 `EsqueletoCarga` — placeholders con shimmer para listas y tarjetas.
  **Toca:** `lib/shared/widgets/retroalimentacion/esqueleto_carga.dart` (nuevo).
  **Hecho:** se ve mejor que el `CircularProgressIndicator` centrado actual; queda disponible para F9.

- [ ] **F4.29** 🔓 Goldens de retroalimentación: vacío, error y carga, en ambos temas.
  **Toca:** `test/shared/retroalimentacion_golden_test.dart` (nuevo).
  **Hecho:** generados y versionados.

### Diálogos y navegación

- [ ] **F4.30** 🔒 `dialogoConfirmacion()` — título, cuerpo, etiquetas configurables y variante destructiva.
  **Toca:** `lib/shared/dialogos/dialogo_confirmacion.dart` (nuevo).
  **Hecho:** reemplaza las **2 copias** del `AlertDialog` de borrado
  ([pantalla_vehiculos.dart:39](lib/pantallas/pantalla_vehiculos.dart#L39),
  [pantalla_servicios.dart:43](lib/pantallas/pantalla_servicios.dart#L43)).
  Corrige de paso un detalle: hoy el botón "Eliminar" usa `FilledButton` con el color primario,
  cuando una acción destructiva debe leerse como destructiva.

- [ ] **F4.31** 🔓 `MenuAcciones<T>` — el `PopupMenuButton` de editar/eliminar, parametrizado.
  **Toca:** `lib/shared/widgets/navegacion/menu_acciones.dart` (nuevo).
  **Hecho:** reemplaza las **3 copias** del `PopupMenuButton` de las pantallas de listado.

- [ ] **F4.32** 🔓 `BarraSuperior` — `AppBar` con la variante de subtítulo que hoy se resuelve con un
  `PreferredSize` + `Padding` a mano en dos pantallas
  ([pantalla_vehiculos.dart:83](lib/pantallas/pantalla_vehiculos.dart#L83),
  [pantalla_servicios.dart:87](lib/pantallas/pantalla_servicios.dart#L87)).
  **Toca:** `lib/shared/widgets/navegacion/barra_superior.dart` (nuevo).
  **Hecho:** el subtítulo es un parámetro, no un hack de altura fija.

### Utilidades y cierre

- [ ] **F4.33** 🔓 `Formatos` — fecha, moneda y kilometraje centralizados con cifras tabulares.
  **Toca:** `lib/core/utilidades/formatos.dart` (nuevo).
  **Hecho:** reemplaza los `DateFormat('dd/MM/yyyy')` duplicados en
  [pantalla_servicios.dart:16](lib/pantallas/pantalla_servicios.dart#L16) y
  [formulario_servicio.dart:24](lib/pantallas/formulario_servicio.dart#L24), y el `_precio()` privado.

- [ ] **F4.34** 🔓 `Validadores` — reglas de formulario reutilizables (obligatorio, largo máximo,
  rango entero, decimal positivo).
  **Toca:** `lib/core/utilidades/validadores.dart` (nuevo).
  **Hecho:** los 3 formularios podrán componer validadores en vez de escribir closures.
  Se respeta la regla del proyecto: **no se replican las reglas de negocio del backend**, solo formato.

- [ ] **F4.35** 🔓 Barrel de `shared`.
  **Toca:** `lib/shared/shared.dart` (nuevo).
  **Hecho:** un import alcanza para toda la capa.

- [ ] **F4.36** 🔓 Extender la galería de F2.21 con todos los componentes nuevos.
  **Toca:** `lib/core/design_system/galeria_tokens.dart`.
  **Hecho:** la galería muestra cada componente en cada estado, en ambos temas.

- [ ] **F4.37** ✅ **Cierre de fase:** analyze + test verdes, todos los goldens generados.
  Las pantallas **todavía no consumen** los componentes — eso es F9.

---

# F5 · Reestructura a features (dominio / datos / presentación)

> Puramente mecánica: **ningún cambio visual**. Se hace una feature por vez, dejando el árbol verde
> en cada paso. Va antes de routing para que las rutas apunten a las ubicaciones definitivas.

- [ ] **F5.1** 🔒 Mover `lib/api/api_base.dart` → `lib/core/red/cliente_http.dart`.
  **Toca:** `lib/core/red/cliente_http.dart` (nuevo), los 3 archivos de API.
  **Hecho:** `construirUri`, `decodificar` y `ejecutar` siguen funcionando igual.

- [ ] **F5.2** 🔒 Mover `lib/api/excepciones.dart` → `lib/core/red/excepciones.dart`.
  **Toca:** `lib/core/red/excepciones.dart` (nuevo).
  **Hecho:** `ExcepcionApi` y `ExcepcionConexion` sin cambios de comportamiento.

- [ ] **F5.3** 🔓 Revisar `construirUri`: hoy usa `base.replace(path: ruta)`, que **descarta cualquier
  path del `API_URL`**. Funciona porque la URL base no tiene path, pero se rompe silenciosamente si algún
  día apunta a `https://host/api/v2`.
  **Toca:** `lib/core/red/cliente_http.dart`.
  **Hecho:** o se corrige concatenando, o se documenta la restricción con un `///`.

### Feature clientes (patrón de referencia)

- [ ] **F5.4** 🔒 Entidad de dominio `Cliente` — solo campos y lógica de negocio, **sin serialización**.
  **Toca:** `lib/features/clientes/dominio/cliente.dart` (nuevo).
  **Hecho:** el archivo no importa `dart:convert` ni sabe qué es JSON.

- [ ] **F5.5** 🔒 Interfaz `abstract class RepositorioClientes` con las 5 operaciones
  (listar, obtener, crear, reemplazar, cambiarEstado).
  **Toca:** `lib/features/clientes/dominio/repositorio_clientes.dart` (nuevo).
  **Hecho:** la interfaz habla de entidades de dominio, no de `http.Response`.

- [ ] **F5.6** 🔒 `ClienteDto` con `desdeJson` / `aJson` / `aDominio` / `desdeDominio`.
  **Toca:** `lib/features/clientes/datos/cliente_dto.dart` (nuevo).
  **Hecho:** toda la serialización que hoy vive en el modelo queda acá.

- [ ] **F5.7** 🔒 `FuenteRemotaClientes` — `ApiCliente` renombrada, hablando DTOs.
  **Toca:** `lib/features/clientes/datos/fuente_remota_clientes.dart` (nuevo).
  **Hecho:** mismos endpoints, mismo comportamiento.

- [ ] **F5.8** 🔒 `RepositorioClientesHttp implements RepositorioClientes` — traduce DTO ↔ dominio.
  **Toca:** `lib/features/clientes/datos/repositorio_clientes_http.dart` (nuevo).
  **Hecho:** las pantallas dependen de la interfaz, nunca de la implementación.

- [ ] **F5.9** 🔒 Providers de la feature: `repositorioClientesProvider`, `clientesProvider`,
  `clientePorIdProvider`.
  **Toca:** `lib/features/clientes/presentacion/proveedores/clientes_proveedores.dart` (nuevo).
  **Hecho:** `clientePorIdProvider` es nuevo y lo necesita F6 para los deep links.

- [ ] **F5.10** 🔓 **Corregir el `ref.read` dentro del provider.**
  [proveedores.dart:18](lib/estado/proveedores.dart#L18) usa `ref.read(apiClienteProvider)` donde
  corresponde `ref.watch`: con `read`, si el provider del repositorio se sobrescribe o invalida,
  el de clientes no se entera.
  **Toca:** `lib/features/clientes/presentacion/proveedores/clientes_proveedores.dart`.
  **Hecho:** `ref.watch` en los tres providers de lista.

- [ ] **F5.11** 🔒 Mover las pantallas de clientes a `presentacion/pantallas/`, ajustando imports.
  **Toca:** `lib/features/clientes/presentacion/pantallas/` (nuevo), borrar los originales.
  **Hecho:** la app compila y se comporta igual.

- [ ] **F5.12** 🔓 Mover `_FilaCliente` (hoy privada en la pantalla) a
  `presentacion/widgets/tarjeta_cliente.dart`.
  **Toca:** `lib/features/clientes/presentacion/widgets/tarjeta_cliente.dart` (nuevo).
  **Hecho:** la pantalla queda más corta y el widget es testeable por separado.

- [ ] **F5.13** 🔓 Actualizar los tests de clientes a la estructura nueva.
  **Toca:** `test/features/clientes/`.
  **Hecho:** `flutter test` verde.

### Feature vehículos

- [ ] **F5.14** 🔓 Entidad `Vehiculo` (conservando `descripcionCorta`).
  **Toca:** `lib/features/vehiculos/dominio/vehiculo.dart` (nuevo).
  **Hecho:** sin serialización.

- [ ] **F5.15** 🔓 Interfaz `RepositorioVehiculos` (incluye `porPatente`, que existe en la API y hoy
  ninguna pantalla usa).
  **Toca:** `lib/features/vehiculos/dominio/repositorio_vehiculos.dart` (nuevo).
  **Hecho:** las 6 operaciones declaradas.

- [ ] **F5.16** 🔓 `VehiculoDto`, `FuenteRemotaVehiculos`, `RepositorioVehiculosHttp`.
  **Toca:** `lib/features/vehiculos/datos/` (3 archivos nuevos).
  **Hecho:** mismos endpoints, mismo comportamiento.

- [ ] **F5.17** 🔓 Providers: `repositorioVehiculosProvider`, `vehiculosPorClienteProvider`,
  `vehiculoPorIdProvider`.
  **Toca:** `lib/features/vehiculos/presentacion/proveedores/vehiculos_proveedores.dart` (nuevo).
  **Hecho:** `vehiculoPorIdProvider` es nuevo y lo necesita F6.

- [ ] **F5.18** 🔓 Mover pantalla y formulario de vehículos, extrayendo `TarjetaVehiculo`.
  **Toca:** `lib/features/vehiculos/presentacion/`.
  **Hecho:** compila y se comporta igual.

- [ ] **F5.19** 🔓 Tests de vehículos.
  **Toca:** `test/features/vehiculos/` (nuevo).
  **Hecho:** cubren listar y el estado vacío. *Hoy vehículos no tiene ningún test.*

### Feature servicios

- [ ] **F5.20** 🔓 Entidad `Servicio`.
  **Toca:** `lib/features/servicios/dominio/servicio.dart` (nuevo).
  **Hecho:** sin serialización.

- [ ] **F5.21** 🔓 Interfaz `RepositorioServicios`.
  **Toca:** `lib/features/servicios/dominio/repositorio_servicios.dart` (nuevo).
  **Hecho:** las 5 operaciones declaradas.

- [ ] **F5.22** 🔓 `ServicioDto`, `FuenteRemotaServicios`, `RepositorioServiciosHttp`.
  **Toca:** `lib/features/servicios/datos/` (3 archivos nuevos).
  **Hecho:** se conserva el formato de fecha `yyyy-MM-dd` que espera el backend
  ([servicio.dart:25](lib/modelos/servicio.dart#L25)).

- [ ] **F5.23** 🔓 Providers: `repositorioServiciosProvider`, `serviciosPorVehiculoProvider`.
  **Toca:** `lib/features/servicios/presentacion/proveedores/servicios_proveedores.dart` (nuevo).
  **Hecho:** con `ref.watch`.

- [ ] **F5.24** 🔓 Mover el total acumulado (`lista.fold`, hoy calculado dentro del `build` en
  [pantalla_servicios.dart:107](lib/pantallas/pantalla_servicios.dart#L107)) a un provider derivado
  o a un método de dominio.
  **Toca:** `lib/features/servicios/dominio/` o `presentacion/proveedores/`.
  **Hecho:** el `build` no hace cálculos de negocio.

- [ ] **F5.25** 🔓 Mover pantalla y formulario de servicios, extrayendo `TarjetaServicio` y
  `ResumenServicios`.
  **Toca:** `lib/features/servicios/presentacion/`.
  **Hecho:** compila y se comporta igual.

- [ ] **F5.26** 🔓 Corregir el `DateFormat` como campo de instancia en un `ConsumerWidget`:
  [pantalla_servicios.dart:14](lib/pantallas/pantalla_servicios.dart#L14) tiene un constructor **no `const`**
  solo para poder guardar `_formatoFecha`.
  **Toca:** `lib/features/servicios/presentacion/pantallas/pantalla_servicios.dart`.
  **Hecho:** usa `Formatos` de F4.33 y el constructor vuelve a ser `const`.

- [ ] **F5.27** 🔓 Tests de servicios.
  **Toca:** `test/features/servicios/` (nuevo).
  **Hecho:** cubren el listado, el vacío y el cálculo del total.

### Limpieza

- [ ] **F5.28** 🔒 Borrar `lib/api/`, `lib/modelos/`, `lib/estado/`, `lib/pantallas/` y `lib/widgets/`.
  **Toca:** las 5 carpetas viejas.
  **Hecho:** `lib/` solo contiene `main.dart`, `app/`, `core/`, `shared/`, `features/`.

- [ ] **F5.29** 🔓 Verificar que no quedaron imports relativos cruzando entre features
  (`features/vehiculos/…` importando `features/clientes/…` fuera de `dominio/`).
  **Toca:** todo `lib/features/`.
  **Hecho:** grep sin resultados. Una feature solo depende de `core/`, `shared/` y de su propio dominio.

- [ ] **F5.30** ✅ **Cierre de fase:** analyze + test verdes, build web exitoso, y **la app se ve y se
  comporta exactamente igual que antes de la fase**. Ese es el criterio de que la reestructura salió bien.

---

# F6 · Migración a go_router

> Centralizar la definición de pantallas, ganar URLs reales en web y deep links.
> **Depende de F5** (las rutas apuntan a ubicaciones definitivas).

- [ ] **F6.1** 🔒 Definir los paths como constantes, espejando la jerarquía del modelo:
  `/clientes`, `/clientes/nuevo`, `/clientes/:clienteId/editar`,
  `/clientes/:clienteId/vehiculos`, `/clientes/:clienteId/vehiculos/nuevo`,
  `/clientes/:clienteId/vehiculos/:vehiculoId/editar`,
  `/clientes/:clienteId/vehiculos/:vehiculoId/servicios`, `…/servicios/nuevo`,
  `…/servicios/:servicioId/editar`, `/ajustes`.
  **Toca:** `lib/core/routing/rutas.dart` (nuevo).
  **Hecho:** ningún string de ruta se escribe literal en otro archivo.

- [ ] **F6.2** 🔒 **Decidir la estrategia de URL.**
  En GitHub Pages, con path strategy, refrescar `/clientes/5/vehiculos` da **404**: Pages sirve archivos
  estáticos y no reescribe al `index.html`.
  **Opciones:** (a) mantener el hash strategy por defecto (`/#/clientes/5/vehiculos`) — funciona sin
  configurar nada; (b) `usePathUrlStrategy()` + copiar `index.html` a `404.html` en el workflow.
  **Recomendación: (a)**, y pasar a (b) solo si las URLs limpias importan.
  **Toca:** `lib/main.dart`, `.github/workflows/desplegar.yml`.
  **Hecho:** decisión anotada acá y **verificada en el deploy real**, no asumida.

- [ ] **F6.3** 🔒 Crear el `GoRouter` como provider (para poder redirigir según estado más adelante).
  **Toca:** `lib/core/routing/router.dart` (nuevo).
  **Hecho:** `MaterialApp.router` lo consume desde Riverpod.

- [ ] **F6.4** 🔒 Cambiar `MaterialApp` por `MaterialApp.router`.
  **Toca:** `lib/app/aplicacion.dart`.
  **Hecho:** la app arranca en `/clientes`.

- [ ] **F6.5** 🔒 **Pantallas por ID, no por objeto.**
  Hoy `PantallaVehiculos({required Cliente cliente})` y `PantallaServicios({required Vehiculo vehiculo})`
  reciben el objeto completo, lo que es incompatible con entrar por URL.
  Pasan a recibir `clienteId` / `vehiculoId` y resolver el objeto vía `clientePorIdProvider` /
  `vehiculoPorIdProvider` (F5.9, F5.17), usando `extra` como camino rápido cuando la navegación es interna
  para no refetchear.
  **Toca:** las pantallas de vehículos y servicios.
  **Hecho:** pegar la URL en el navegador y refrescar carga la pantalla correcta.
  *Es el paso de más riesgo de la fase.*

- [ ] **F6.6** 🔓 Reemplazar los `Navigator.push` de clientes por `context.go` / `context.push`.
  **Toca:** `lib/features/clientes/presentacion/`.
  **Hecho:** ningún `MaterialPageRoute` en la feature.

- [ ] **F6.7** 🔓 Ídem en vehículos.
  **Toca:** `lib/features/vehiculos/presentacion/`.
  **Hecho:** ídem.

- [ ] **F6.8** 🔓 Ídem en servicios.
  **Toca:** `lib/features/servicios/presentacion/`.
  **Hecho:** ídem.

- [ ] **F6.9** 🔒 **Reemplazar el patrón `pop(true)` → `invalidate`.**
  Hoy el formulario devuelve `true` y la pantalla anterior invalida
  ([pantalla_clientes.dart:34](lib/pantallas/pantalla_clientes.dart#L34) y sus 2 gemelos).
  Con go_router el resultado del `pop` deja de ser confiable. Nuevo patrón: el formulario invalida el
  provider de la lista al guardar y hace `context.pop()`.
  **Toca:** los 3 formularios.
  **Hecho:** guardar refresca la lista. Elimina las **3 copias** de `_abrirFormulario`.

- [ ] **F6.10** 🔓 Ruta de error 404 con una pantalla propia.
  **Toca:** `lib/core/routing/router.dart`, `lib/shared/widgets/retroalimentacion/pantalla_no_encontrada.dart` (nuevo).
  **Hecho:** una URL inválida muestra algo útil, no la pantalla roja de Flutter.

- [ ] **F6.11** 🔓 Manejar el ID inexistente: `/clientes/9999/vehiculos` cuando el cliente no existe.
  **Toca:** las pantallas con parámetro de ruta.
  **Hecho:** muestra `VistaError` con acción de volver, no una excepción.

- [ ] **F6.12** 🔓 Manejar el ID no numérico: `/clientes/abc/vehiculos`.
  **Toca:** `lib/core/routing/router.dart`.
  **Hecho:** `int.tryParse` fallido redirige al 404, no lanza.

- [ ] **F6.13** 🔓 Transiciones de ruta usando los tokens de duración de F1.9.
  **Toca:** `lib/core/routing/transiciones.dart` (nuevo).
  **Hecho:** consistentes entre plataformas; sin animación de página en web (donde se siente lenta).

- [ ] **F6.14** 🔓 Verificar el botón "atrás" del navegador en los 3 niveles de la jerarquía.
  **Toca:** —
  **Hecho:** el back navega correctamente en toda la profundidad.

- [ ] **F6.15** 🔓 Verificar el botón "atrás" físico de Android, incluido salir de un formulario a medio llenar.
  **Toca:** —
  **Hecho:** sin rutas huérfanas ni pantallas duplicadas en la pila.

- [ ] **F6.16** 🔓 Helpers de navegación tipados (`irAVehiculos(context, clienteId)`) para no construir
  paths a mano con interpolación.
  **Toca:** `lib/core/routing/rutas.dart`.
  **Hecho:** ninguna pantalla concatena strings de ruta.

- [ ] **F6.17** 🔓 Adaptar el helper de test de F0.12 para montar pantallas con un router de prueba.
  **Toca:** `test/ayudas/bombear_pantalla.dart`.
  **Hecho:** los tests de pantallas con parámetros de ruta pasan.

- [ ] **F6.18** 🔓 Test de rutas: cada path definido resuelve a la pantalla esperada.
  **Toca:** `test/core/routing/router_test.dart` (nuevo).
  **Hecho:** verde para los 10 paths.

- [ ] **F6.19** 🔓 Test de deep link: entrar directo a servicios y verificar que resuelve cliente y
  vehículo desde los IDs.
  **Toca:** `test/core/routing/router_test.dart`.
  **Hecho:** verde con repositorios falsos.

- [ ] **F6.20** ✅ **Cierre de fase:** analyze + test verdes, y **verificación en el deploy real de Pages**
  con `--base-href` (F6.2 no se da por cerrado hasta comprobarlo en producción).

---

# F7 · Layout responsive y adaptativo

> El mismo código Flutter respondiendo a móvil, tablet y escritorio.
> **Depende de F6.**

- [ ] **F7.1** 🔒 Definir `enum PuntoCorte { compacto, medio, expandido }` con los umbrales del
  design-system: `< 640` / `640–1024` / `> 1024`.
  **Toca:** `lib/core/layout/puntos_corte.dart` (nuevo).
  **Hecho:** los umbrales coinciden con DESIGN.md. El tramo `> 1024` queda **confirmado** contra
  `mockups/screen4.png` y `screen6.png` (versión web real, sidebar persistente + contenido a dos columnas) —
  ya no es derivado a ciegas.

- [ ] **F7.2** 🔒 `extension ContextoLayout on BuildContext` → `context.puntoCorte`, `context.esCompacto`,
  `context.bordePantalla` (16 en móvil, 24 en tablet+).
  **Toca:** `lib/core/layout/contexto_layout.dart` (nuevo).
  **Hecho:** una pantalla decide su layout con una línea.

- [ ] **F7.3** 🔓 `ContenedorContenido` — ancho máximo legible y centrado, para que en escritorio
  el texto no se estire a 2000px.
  **Toca:** `lib/core/layout/contenedor_contenido.dart` (nuevo).
  **Hecho:** en una ventana ancha el contenido queda centrado y acotado.

- [ ] **F7.4** 🔒 `AndamioAdaptativo` — `NavigationBar` inferior en compacto, `NavigationRail` lateral
  en medio/expandido, con el mismo conjunto de destinos.
  `mockups/screen4.png`/`screen6.png` muestran un **rail extendido con etiquetas** (no solo íconos) en
  desktop — el rail de `expandido` lleva `extended: true`; el de `medio` puede quedar solo-ícono.
  **Toca:** `lib/core/layout/andamio_adaptativo.dart` (nuevo).
  **Hecho:** redimensionar la ventana web cruza entre los dos sin perder el estado de la pantalla.

- [ ] **F7.5** 🔓 Definir los destinos de navegación (Clientes, Ajustes; extensible).
  **Toca:** `lib/core/routing/destinos.dart` (nuevo).
  **Hecho:** agregar un destino es agregar una entrada a una lista.

- [ ] **F7.6** 🔒 `ShellRoute` de go_router envolviendo las rutas principales con el andamio.
  **Toca:** `lib/core/routing/router.dart`.
  **Hecho:** la navegación persiste entre cambios de ruta; los formularios quedan fuera del shell
  (van a pantalla completa).

- [ ] **F7.7** 🔓 Mover el acceso a ajustes del `AppBar` (F3.8) a un destino de navegación.
  **Toca:** `lib/features/clientes/presentacion/pantallas/`, `lib/core/routing/destinos.dart`.
  **Hecho:** el `AppBar` de clientes queda limpio.

- [ ] **F7.8** 🔒 `PanelMaestroDetalle` — lista + detalle lado a lado en medio/expandido, navegación
  apilada en compacto.
  **Toca:** `lib/core/layout/panel_maestro_detalle.dart` (nuevo).
  **Hecho:** el mismo widget resuelve los dos modos sin duplicar la pantalla.

- [ ] **F7.9** 🔓 Aplicar master-detail a clientes → vehículos.
  **Toca:** `lib/features/clientes/presentacion/pantallas/`.
  **Hecho:** en tablet, seleccionar un cliente muestra sus vehículos al costado sin cambiar de pantalla.

- [ ] **F7.10** 🔓 Aplicar master-detail a vehículos → servicios.
  **Toca:** `lib/features/vehiculos/presentacion/pantallas/`.
  **Hecho:** ídem un nivel más abajo.

- [ ] **F7.11** 🔓 Grilla adaptativa para las listas: 1 columna en compacto, 2 en medio, 3 en expandido.
  **Toca:** `lib/shared/widgets/superficies/grilla_adaptativa.dart` (nuevo).
  **Hecho:** las tarjetas fluyen sin overflow en ningún ancho.

- [ ] **F7.12** 🔓 Formularios adaptativos: pantalla completa en compacto, diálogo modal centrado con
  ancho máximo en expandido.
  **Toca:** `lib/shared/widgets/superficies/contenedor_formulario.dart` (nuevo).
  **Hecho:** en escritorio, crear un cliente no ocupa 2000px de ancho.

- [ ] **F7.13** 🔓 Padding de borde por breakpoint aplicado en todas las pantallas.
  **Toca:** las 6 pantallas.
  **Hecho:** 16px en móvil, 24px en tablet+, sin literales.

- [ ] **F7.14** 🔓 Manejo del teclado en móvil: los formularios hacen scroll y no tapan el campo enfocado.
  **Toca:** `lib/shared/widgets/superficies/contenedor_formulario.dart`.
  **Hecho:** con el teclado abierto se ve el campo activo y el botón Guardar es alcanzable.

- [ ] **F7.15** 🔓 `SafeArea` correcto en Android con gestos y en notch.
  **Toca:** `lib/core/layout/andamio_adaptativo.dart`.
  **Hecho:** nada queda tapado por las barras del sistema.

- [ ] **F7.16** 🔓 Soporte de teclado físico en web: `Tab` recorre en orden lógico, `Enter` envía,
  `Esc` cierra diálogos.
  **Toca:** `lib/shared/widgets/`.
  **Hecho:** un formulario completo se llena sin tocar el mouse.

- [ ] **F7.17** 🔓 Estados `hover` y `focus` visibles en web (en móvil no existen y hoy no están resueltos).
  **Toca:** `lib/shared/widgets/`, sub-temas de F2.
  **Hecho:** cada elemento interactivo tiene feedback visible de hover y de foco.

- [ ] **F7.18** 🔓 Verificar los targets táctiles de 48/56px en compacto.
  **Toca:** las 6 pantallas.
  **Hecho:** ningún elemento interactivo baja de 48×48.

- [ ] **F7.19** 🔓 Tests de layout con `tester.view.physicalSize` en los 3 breakpoints.
  **Toca:** `test/core/layout/adaptativo_test.dart` (nuevo).
  **Hecho:** verde en los 3 anchos, sin overflow.

- [ ] **F7.20** 🔓 Test de que `NavigationBar` y `NavigationRail` se intercambian en el umbral correcto.
  **Toca:** `test/core/layout/adaptativo_test.dart`.
  **Hecho:** verde.

- [ ] **F7.21** ✅ **Cierre de fase:** analyze + test verdes; probado en Chrome redimensionando y en un
  dispositivo Android real.

---

# F8 · Plantilla de feature

> Que sumar una feature sea copiar, renombrar y llenar. **Depende de F5** (el patrón tiene que existir
> antes de documentarse). No depende de F6 ni F7.

- [ ] **F8.1** 🔓 Crear `docs/plantilla_feature/` con el árbol completo de las 3 capas y archivos de ejemplo.
  **Toca:** `docs/plantilla_feature/` (nuevo).
  **Hecho:** el árbol espeja exactamente el de `features/clientes/`.

- [ ] **F8.2** 🔓 Plantilla de entidad de dominio.
  **Toca:** `docs/plantilla_feature/dominio/entidad.dart.txt`.
  **Hecho:** con marcadores `<Entidad>` claros.

- [ ] **F8.3** 🔓 Plantilla de interfaz de repositorio.
  **Toca:** `docs/plantilla_feature/dominio/repositorio.dart.txt`.
  **Hecho:** ídem.

- [ ] **F8.4** 🔓 Plantillas de DTO, fuente remota e implementación de repositorio.
  **Toca:** `docs/plantilla_feature/datos/`.
  **Hecho:** las 3 con la conversión DTO ↔ dominio ya esbozada.

- [ ] **F8.5** 🔓 Plantilla de providers de feature.
  **Toca:** `docs/plantilla_feature/presentacion/proveedores/`.
  **Hecho:** con `ref.watch`, no `ref.read` (el error que se corrigió en F5.10).

- [ ] **F8.6** 🔓 Plantilla de pantalla de listado, ya armada sobre `VistaAsync` + `FilaLista`.
  **Toca:** `docs/plantilla_feature/presentacion/pantallas/`.
  **Hecho:** cubre carga, error y vacío desde el arranque.

- [ ] **F8.7** 🔓 Plantilla de pantalla de formulario, sobre `SeccionFormulario` + `BotonPrimario`.
  **Toca:** `docs/plantilla_feature/presentacion/pantallas/`.
  **Hecho:** incluye el estado de guardado y el manejo de error vía `Notificador`.

- [ ] **F8.8** 🔓 Plantillas de test: repositorio, providers y pantalla.
  **Toca:** `docs/plantilla_feature/test/`.
  **Hecho:** una feature nueva nace con tests.

- [ ] **F8.9** 🔒 Escribir `docs/COMO_AGREGAR_FEATURE.md`: los pasos en orden, qué registrar en el router,
  en los destinos de navegación y en los barrels.
  **Toca:** `docs/COMO_AGREGAR_FEATURE.md` (nuevo).
  **Hecho:** alguien que no escribió este código puede seguirlo sin preguntar.

- [ ] **F8.10** 🔓 Checklist de "feature terminada" al final de ese documento.
  **Toca:** `docs/COMO_AGREGAR_FEATURE.md`.
  **Hecho:** cubre dominio, datos, presentación, ruta, destino, tests y goldens.

- [ ] **F8.11** 🔓 **Validar la plantilla usándola**: generar una feature descartable siguiendo solo
  el documento, sin mirar el código existente.
  **Toca:** rama temporal.
  **Hecho:** compila y corre. Todo lo que haya que improvisar se corrige en el documento antes de cerrar la fase.
  *Es el único paso que prueba de verdad que la plantilla sirve.*

- [ ] **F8.12** ✅ **Cierre de fase:** documento validado, rama de prueba descartada.

---

# F9 · Rediseño pantalla por pantalla

> Recién acá cambia lo visual a fondo. A esta altura es **ensamblar**: los componentes ya existen y
> están testeados. **Depende de F4, F6 y F7.**
> Cada pantalla se compara contra el mockup de Android **y** el de web antes de darse por hecha.

### Listado de clientes

- [ ] **F9.1** 🔒 Reemplazar el `TextField` inline por `BarraBusqueda`, ganando el debounce.
  **Toca:** `lib/features/clientes/presentacion/pantallas/pantalla_clientes.dart`.
  **Hecho:** buscar filtra mientras se escribe, sin esperar al `onSubmitted`.

- [ ] **F9.2** 🔓 Rehacer los filtros Activos/Inactivos con los chips del tema.
  **Toca:** ídem.
  **Hecho:** coinciden con el mockup; el estado seleccionado se lee de un vistazo.

- [ ] **F9.3** 🔒 `TarjetaCliente` sobre `FilaLista`: avatar, nombre en `title-md`, contacto en `body-md`,
  estado y menú de acciones.
  **Toca:** `lib/features/clientes/presentacion/widgets/tarjeta_cliente.dart`.
  **Hecho:** adiós `ListTile` + `Divider`; toda la tarjeta es un solo target con feedback instantáneo.

- [ ] **F9.4** 🔓 Espaciado de lista: separación de 12px entre tarjetas, borde de pantalla por breakpoint.
  **Toca:** la pantalla de clientes.
  **Hecho:** sin `EdgeInsets` literales.

- [ ] **F9.5** 🔓 `VistaVacia` con acción "Crear el primer cliente".
  **Toca:** ídem.
  **Hecho:** el estado vacío ofrece salida en vez de solo informar.

- [ ] **F9.6** 🔓 Cambiar el spinner centrado por `EsqueletoCarga`.
  **Toca:** ídem.
  **Hecho:** la carga no salta de layout al llegar los datos.

- [ ] **F9.7** 🔓 Revisar el FAB contra el mockup: puede ser barra inferior fija en móvil y FAB en escritorio.
  **Toca:** ídem.
  **Hecho:** decidido contra la imagen, no por defecto.

- [ ] **F9.8** 🔓 `RefreshIndicator` para tirar y refrescar en móvil (hoy solo hay un botón en el `AppBar`).
  **Toca:** ídem.
  **Hecho:** el gesto funciona en Android.

### Listado de vehículos

- [ ] **F9.9** 🔒 `TarjetaVehiculo` sobre `FilaLista`: `InsigniaPatente` arriba, marca/modelo/año en
  `title-md`, kilometraje como `EtiquetaMetadato` con cifras tabulares.
  **Toca:** `lib/features/vehiculos/presentacion/widgets/tarjeta_vehiculo.dart`.
  **Hecho:** la patente es inequívoca (mono, mayúsculas) y los km no bailan entre filas.

- [ ] **F9.10** 🔓 Reemplazar el `PreferredSize` + `Padding` del subtítulo por `BarraSuperior`.
  **Toca:** la pantalla de vehículos.
  **Hecho:** sin el hack de altura fija de 24px.

- [ ] **F9.11** 🔓 `VistaVacia` con acción.
  **Toca:** ídem.
  **Hecho:** ofrece crear el primer vehículo.

- [ ] **F9.12** 🔓 Confirmación de borrado sobre `dialogoConfirmacion`, ahora con estilo destructivo.
  **Toca:** ídem.
  **Hecho:** el botón "Eliminar" se lee como destructivo.

### Historial de servicios

- [ ] **F9.13** 🔒 `TarjetaServicio` sobre `FilaLista`: fecha, descripción con `line-clamp-2`, precio en
  cifras tabulares.
  **Toca:** `lib/features/servicios/presentacion/widgets/tarjeta_servicio.dart`.
  **Hecho:** las descripciones largas no rompen la altura de la tarjeta.

- [ ] **F9.14** 🔒 Rehacer el encabezado de resumen (hoy un `Container` con
  `color: surfaceContainerHighest` en [pantalla_servicios.dart:114](lib/pantallas/pantalla_servicios.dart#L114))
  como superficie tonal del design-system.
  **Toca:** `lib/features/servicios/presentacion/widgets/resumen_servicios.dart`.
  **Hecho:** consistente con la jerarquía de capas, en claro y oscuro.

- [ ] **F9.15** 🔓 Total y cantidad con cifras tabulares y jerarquía tipográfica correcta.
  **Toca:** ídem.
  **Hecho:** el total se distingue del conteo sin leer las etiquetas.

- [ ] **F9.16** 🔓 `BarraSuperior` con subtítulo de patente.
  **Toca:** la pantalla de servicios.
  **Hecho:** ídem F9.10.

- [ ] **F9.17** 🔓 `VistaVacia` con acción.
  **Toca:** ídem.
  **Hecho:** ofrece registrar el primer servicio.

### Formularios

- [ ] **F9.18** 🔒 Formulario de cliente sobre `CampoTexto` + `SeccionFormulario` + `BotonPrimario`.
  **Toca:** `lib/features/clientes/presentacion/pantallas/formulario_cliente.dart`.
  **Hecho:** cero literales; los validadores salen de `Validadores`.

- [ ] **F9.19** 🔒 Formulario de vehículo: `CampoTexto` para marca/modelo, `CampoNumerico` para año y
  kilometraje, `CampoPatente` para la patente.
  **Toca:** `lib/features/vehiculos/presentacion/pantallas/formulario_vehiculo.dart`.
  **Hecho:** `_validarEntero` desaparece de la pantalla; el teclado numérico aparece donde corresponde.

- [ ] **F9.20** 🔒 Formulario de servicio: `CampoFecha`, `CampoTexto` multilínea, `CampoMoneda`.
  **Toca:** `lib/features/servicios/presentacion/pantallas/formulario_servicio.dart`.
  **Hecho:** el bloque `InkWell` + `InputDecorator` desaparece.

- [ ] **F9.21** 🔓 Barra inferior fija con la acción primaria en los 3 formularios (móvil), según el mockup.
  **Toca:** los 3 formularios.
  **Hecho:** el botón Guardar es alcanzable con el pulgar sin hacer scroll.

- [ ] **F9.22** 🔓 Estados de error de campo consistentes: mensaje bajo el campo, no solo borde rojo.
  **Toca:** `lib/shared/widgets/entradas/`.
  **Hecho:** el error dice qué está mal, y coincide en los 3 formularios.

- [ ] **F9.23** 🔓 Confirmación al salir de un formulario con cambios sin guardar.
  **Toca:** los 3 formularios, `dialogoConfirmacion`.
  **Hecho:** el back físico de Android no descarta trabajo en silencio.

### Ajustes y cierre

- [ ] **F9.24** 🔓 Rediseñar la pantalla de ajustes de F3.6 con los componentes definitivos.
  **Toca:** `lib/features/ajustes/presentacion/pantallas/pantalla_ajustes.dart`.
  **Hecho:** consistente con el resto de la app.

- [ ] **F9.25** 🔓 Previsualización de tema en el selector (una muestra por tema del catálogo).
  **Toca:** ídem.
  **Hecho:** se ve el tema antes de aplicarlo.

- [ ] **F9.26** 🔒 **Auditoría de literales.** Grep de `Color(0x`, `EdgeInsets.all(`, `EdgeInsets.symmetric(`,
  `SizedBox(height:`, `SizedBox(width:`, `BorderRadius.circular(`, `fontSize:` fuera de `core/design_system/`.
  **Toca:** todo `lib/`.
  **Hecho:** **cero resultados**. Es el criterio duro del objetivo "nada hardcodeado en las pantallas".

- [ ] **F9.27** 🔓 Comparación lado a lado contra los mockups de Android, pantalla por pantalla.
  **Toca:** —
  **Hecho:** las diferencias están anotadas y resueltas, o justificadas por escrito.

- [ ] **F9.28** 🔓 Ídem contra los mockups web.
  **Toca:** —
  **Hecho:** ídem.

- [ ] **F9.29** 🔓 Actualizar los goldens de pantalla completa en ambos temas y los 3 breakpoints.
  **Toca:** `test/features/*/goldens/`.
  **Hecho:** generados y versionados.

### 🆕 Vista global de vehículos (opcional, judgment call)

Los mockups muestran "Vehículos" como destino de primer nivel (bottom nav Android, sidebar web), no
anidado bajo un cliente. A diferencia del resto del backlog, **esto no requiere backend nuevo**:
`ApiVehiculo.listar()` ya acepta `clienteId` nulo (todos los vehículos) y `porPatente()` ya existe
([api_vehiculo.dart:11](lib/api/api_vehiculo.dart#L11),
[api_vehiculo.dart:32](lib/api/api_vehiculo.dart#L32)) — hoy ninguna pantalla los usa. Encaja en "reskin
puro" sin ampliar el alcance, pero sí agrega un destino de navegación nuevo, así que queda marcado como
opcional en vez de asumido.

- [ ] **F9.30** 🔓 **[Opcional]** `PantallaVehiculosGlobal`: lista todos los vehículos con `BarraBusqueda`
  filtrando por patente (usa `porPatente`), cada `TarjetaVehiculo` navega a su historial de servicios.
  **Toca:** `lib/features/vehiculos/presentacion/pantallas/pantalla_vehiculos_global.dart` (nuevo),
  `lib/core/routing/rutas.dart` (agrega `/vehiculos`), `lib/core/routing/destinos.dart`.
  **Hecho:** un mecánico puede llegar a un vehículo por patente sin pasar por su cliente.
  **Si se descarta:** no bloquea nada — el resto de F9 no depende de este paso.

- [ ] **F9.31** 🔓 **[Opcional]** Agregar "Vehículos" como destino de `AndamioAdaptativo` (F7.5),
  junto a Clientes y Ajustes.
  **Toca:** `lib/core/routing/destinos.dart`.
  **Hecho:** visible en `NavigationBar` y `NavigationRail`.

- [ ] **F9.32** ✅ **Cierre de fase:** analyze + test verdes, build web exitoso, revisión visual completa.

---

# F10 · Pulido y verificación

> Lo que separa "está terminado" de "funciona".

- [ ] **F10.1** 🔓 Auditoría de accesibilidad: `Semantics` en íconos sin texto, labels en los botones de
  ícono, orden de lectura coherente.
  **Toca:** `lib/shared/widgets/`, las 6 pantallas.
  **Hecho:** TalkBack recorre cada pantalla de forma comprensible.

- [ ] **F10.2** 🔓 Verificar contraste real en pantalla, no solo en el test: claro y oscuro, texto normal
  y grande.
  **Toca:** —
  **Hecho:** todo pasa AA. El design-system apunta a "legibilidad absoluta en luz variable" — este es el
  paso donde se comprueba.

- [ ] **F10.3** 🔓 Verificar targets táctiles con el inspector: ninguno bajo 48×48.
  **Toca:** —
  **Hecho:** confirmado en las 6 pantallas.

- [ ] **F10.4** 🔓 Verificar cifras tabulares en km, precios, años y fechas: alineadas verticalmente
  en listas.
  **Toca:** `lib/core/design_system/tokens/tipografia.dart`, `lib/core/utilidades/formatos.dart`.
  **Hecho:** los dígitos no bailan al hacer scroll.

- [ ] **F10.5** 🔓 Verificar que las patentes usan mono en mayúsculas en todos los lugares donde aparecen.
  **Toca:** `lib/features/vehiculos/`, `lib/features/servicios/`.
  **Hecho:** `0` y `O` son distinguibles en toda la app.

- [ ] **F10.6** 🔓 Probar con textos largos: nombre de cliente de 100 caracteres, descripción de servicio
  de 2000 (los máximos que aceptan los validadores).
  **Toca:** —
  **Hecho:** sin overflow ni `RenderFlex` en ningún breakpoint.

- [ ] **F10.7** 🔓 Probar con la escala de fuente del sistema al 200%.
  **Toca:** —
  **Hecho:** la app sigue siendo usable; nada se corta.

- [ ] **F10.8** 🔓 Probar sin conexión: verificar que `ExcepcionConexion` se muestra bien en las 6 pantallas.
  **Toca:** —
  **Hecho:** el mensaje es claro y el botón Reintentar funciona.

- [ ] **F10.9** 🔓 Verificar que los mensajes de error del backend siguen llegando enteros a la interfaz
  (es una propiedad explícita del proyecto, y `Notificador` la podría haber roto).
  **Toca:** `lib/shared/widgets/retroalimentacion/notificador.dart`.
  **Hecho:** una validación fallida del backend se lee tal cual en pantalla.

- [ ] **F10.10** 🔓 Revisar tiempos de arranque en web: peso del bundle y de las fuentes.
  **Toca:** `pubspec.yaml`, `web/`.
  **Hecho:** medido y anotado; si las 7 fuentes pesan demasiado, reducir pesos.

- [ ] **F10.11** 🔓 Verificar que el `favicon` y los íconos de PWA acompañan la identidad nueva.
  **Toca:** `web/icons/`, `web/favicon.png`.
  **Hecho:** los íconos ya no son los de `flutter create`.

- [ ] **F10.12** 🔓 Ícono y `label` de la app en Android.
  **Toca:** `android/app/src/main/res/`, `android/app/src/main/AndroidManifest.xml`.
  **Hecho:** ídem.

- [ ] **F10.13** 🔓 Pasada final de comentarios sobre todo `lib/`: eliminar cualquier `//` que haya
  entrado durante la migración; verificar que los `///` de `core/` y `shared/` describen contrato,
  no implementación.
  **Toca:** todo `lib/`.
  **Hecho:** grep de `//` (excluyendo `///` y URLs) sin resultados en `lib/`.

- [ ] **F10.14** 🔓 Reescribir la sección "Estructura" del README con el árbol definitivo.
  **Toca:** `README.md`.
  **Hecho:** refleja la realidad post-migración.

- [ ] **F10.15** 🔓 Documentar el design-system en el README: dónde viven los tokens, cómo agregar un tema,
  cómo agregar un componente compartido.
  **Toca:** `README.md`, `docs/`.
  **Hecho:** un lector entiende dónde tocar sin abrir 10 archivos.

- [ ] **F10.16** 🔓 Actualizar `FLUJO.md`, que describe la arquitectura de 5 capas anterior.
  **Toca:** `FLUJO.md`.
  **Hecho:** el recorrido documentado coincide con el código.
  *Nota: `FLUJO.md` está en `.gitignore`, es documento personal — actualizarlo igual, se usa para estudiar.*

- [ ] **F10.17** 🔓 Agregar un job de goldens al CI para que una regresión visual falle el build.
  **Toca:** `.github/workflows/desplegar.yml`.
  **Hecho:** el workflow corre los goldens y falla si difieren.

- [ ] **F10.18** ✅ **Verificación final end-to-end:**
  1. `flutter analyze` sin issues
  2. `flutter test` verde, goldens incluidos
  3. `flutter build web --release --base-href /ParqueInyeccion33Front/` exitoso
  4. `flutter run -d chrome`: recorrer los 3 niveles, crear/editar/eliminar en cada entidad
  5. Alternar claro/oscuro y repetir el recorrido
  6. Redimensionar cruzando los 3 breakpoints
  7. Pegar una URL profunda y refrescar
  8. `flutter run` en un Android real: recorrido completo, back físico, teclado, escala de fuente
  9. Comparar contra los mockups por última vez

---

## Backlog — fuera de este roadmap

Los 6 mockups (`mockups/screen1-6.png`) describen un sistema de gestión de taller bastante más grande que
las 3 entidades actuales. Este roadmap decidió **reskin puro**: F9 toma de las imágenes solo lo que mapea a
datos reales, y todo lo que sigue queda **documentado, no planificado en detalle ni construido acá**. Sirve
como mapa para un roadmap de producto aparte, el día que se decida encararlo — toca backend en Java además
del frontend.

Nota aparte: `mockups/screen1.png` y `screen2.png` son la misma imagen — probablemente un duplicado al
guardar; si había una segunda pantalla de clientes distinta (otro estado, otro filtro), volver a exportarla.

| Funcionalidad del mockup | Dónde se ve | Backend nuevo necesario | Esfuerzo |
|---|---|---|---|
| **Órdenes de Trabajo** | screen1-2 ("Órdenes" en nav), screen3-4 ("Crear Orden de Trabajo"), screen5-6 (línea de tiempo con `#WO-2025-084`, estado, desglose ítem/categoría/cantidad/subtotal, mecánico, garantía) | Entidad `OrdenTrabajo` (estado, vehículo, ítems de línea, mecánico asignado, total, garantía) reemplazando/extendiendo `Servicio` | Grande |
| **Inventario / Repuestos** | screen4-6 (sidebar web, ítems de repuesto con código en el desglose) | Entidad `Repuesto` (stock, precio, categoría, código) + relación con ítems de orden | Grande |
| **Mecánicos** | screen3-6 ("Mecánico asignado", "Bahía 2", "Especialidad: Suspensión y Dirección") | Entidad `Mecanico` (nombre, especialidad, bahía) + asignación a órdenes | Mediano |
| **Autenticación y roles** | screen4-6 (usuario "Carlos Méndez / Jefe de Taller", Cerrar Sesión, sidebar completo vs. nav simple) | Usuarios + roles + login; en frontend, pantalla de login y guardas de ruta en go_router | Grande |
| **Notificaciones** | screen4-6 (campana con punto rojo) | Tabla de eventos/notificaciones + endpoint de listado | Mediano |
| **Búsqueda global** | screen4 ("Buscar patente, DNI o ficha…"), screen6 ("Buscar chasis, orden o repuesto…") | Endpoint de búsqueda cruzada entre entidades | Mediano |
| **Cliente enriquecido** | screen3-4 (email, CUIT/DNI, domicilio, "Verificado", "Cliente desde…", facturación histórica, notas internas, fidelización) | Campos nuevos en `Cliente` + tabla de notas internas (autor, fecha) | Mediano |
| **Vehículo enriquecido** | screen3-6 (chasis/VIN, motor, tipo de carrocería/transmisión, chip de estado operativo, "Nota de Atención Mecánica", próximo service estimado, inversión acumulada) | Campos nuevos en `Vehiculo` + cálculo agregado sobre su historial de servicios | Mediano |
| **Servicio → línea de orden** | screen5-6 (desglose ítem/categoría/cantidad/subtotal en vez de un precio único) | `Servicio` pasa de `{descripcion, precio}` a una orden con ítems de línea — depende de "Órdenes de Trabajo" | Grande (subsumido en la fila 1) |
| **Compartir / exportar** | screen4 ("Compartir por WhatsApp"), screen6 ("Descargar Informe PDF", "Exportar Historial Completo") | Generación de PDF en backend o cliente; integración de share intent | Chico–Mediano |
| **Garantías** | screen3-6 ("Garantías Activas: 1, vigente x 60 días", "Historial Técnico Certificado… garantía de 90 días o 5.000 km") | Campo de garantía en la orden + regla de vigencia | Chico |
| **Vista global de vehículos** | screen1-4 ("Vehículos" en nav) | **Ninguno** — `ApiVehiculo.listar()` sin `clienteId` y `porPatente()` ya existen | Incluido como opcional en **F9.30–F9.31** |

**Si en algún momento se decide avanzar con esto:** empezar por Mecánicos y Órdenes de Trabajo (todo lo
demás depende de o se apoya en esas dos), y planificar el backend Java antes que el frontend — el patrón
de features de F8 sirve igual para las entidades nuevas.

---

## Resumen

| Fase | Pasos | Dependencias | Resultado observable |
|---|---|---|---|
| F0 · Preparación | 18 | — | CI protegido, fuentes listas |
| F1 · Tokens | 15 | F0.4 | *Nada cambia* (correcto) |
| F2 · Temas | 22 | F1 | *Nada cambia* (correcto) |
| F3 · Cableado | 14 | F2 | **Primer cambio visual** |
| F4 · Componentes | 37 | F2 | Duplicación eliminada |
| F5 · Features | 30 | — | *Nada cambia* (correcto) |
| F6 · go_router | 20 | F5 | URLs reales, deep links |
| F7 · Responsive | 21 | F6 | Adaptación a 3 tamaños |
| F8 · Plantilla | 12 | F5 | Feature nueva en minutos |
| F9 · Rediseño | 32 | F4, F6, F7 | **La app se ve como el mockup** |
| F10 · Pulido | 18 | F9 | Listo para producción |
| **Total** | **239** | | |

**F1, F2 y F5 no cambian nada visualmente, y eso es el criterio de que salieron bien.**
Si algo se ve distinto al terminar esas fases, hay un efecto colateral que no debería estar.

### Duplicación que se elimina

| Patrón duplicado | Copias hoy | Se resuelve en |
|---|---|---|
| `SnackBar` de error | 6 | F4.27 `Notificador` |
| Botón Guardar con spinner | 3 | F4.1 `BotonPrimario` |
| `PopupMenuButton` editar/eliminar | 3 | F4.31 `MenuAcciones` |
| `_abrirFormulario` + `invalidate` | 3 | F6.9 |
| `AlertDialog` de confirmación | 2 | F4.30 `dialogoConfirmacion` |
| `DateFormat('dd/MM/yyyy')` | 2 | F4.33 `Formatos` |
| `PreferredSize` de subtítulo | 2 | F4.32 `BarraSuperior` |
| `border: OutlineInputBorder()` | 8 | F2.10 `InputDecorationTheme` |

### Pendientes de confirmar

- **F1.1** — resuelto contra los mockups; los hex son una lectura visual aproximada (sin color-picker),
  aceptada como punto de partida. Se ajustan sobre la marcha si algún contraste no cierra al implementar.
- **F1.3** — la escala tipográfica más allá de `headline-lg` sigue derivada; los mockups no permiten
  confirmar tamaños exactos a simple vista. Revisar en F9.27/F9.28 contra las capturas.
- **F1.12** — la paleta oscura se presenta para aprobación antes de cablearse (ningún mockup trae oscuro).
- **F6.2** — la estrategia de URL hay que verificarla en el deploy real de Pages, no asumirla.
- **F9.30/F9.31** — vista global de vehículos: opcional, a confirmar si se incluye o se deja también
  para el backlog.
