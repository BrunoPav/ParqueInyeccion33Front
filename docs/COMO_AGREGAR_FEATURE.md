# Cómo agregar una feature nueva

Guía para sumar una entidad nueva (dominio + datos + presentación + ruta) siguiendo el mismo patrón
que `clientes`, `vehiculos` y `servicios`. Los templates copiables están en `docs/plantilla_feature/`.

## Antes de empezar: ¿de qué tipo es la feature?

Hay dos formas en las que puede encajar, y cambian el paso 3 (rutas) y el paso 4 (destino de nav):

- **Sección de nivel superior**, como `clientes` o `ajustes`: tiene su propio ítem en
  `NavigationBar`/`NavigationRail` y su ruta cuelga directo de la raíz (`/mi-feature`).
- **Anidada bajo otra entidad**, como `vehiculos` (bajo `clientes`) o `servicios` (bajo `vehiculos`):
  no tiene ítem de navegación propio, se llega a ella desde la pantalla de la entidad padre, y su
  ruta cuelga de la del padre (`/clientes/:clienteId/mi-feature`).

## Convención de nombres

Los templates usan 4 placeholders. Reemplazarlos exactamente así, sin mezclar mayúsculas/minúsculas:

| Placeholder | Forma | Ejemplo (si la entidad es "Turno") | Dónde se usa |
|---|---|---|---|
| `<Entidad>` | PascalCase singular | `Turno` | Nombres de clase |
| `<entidad>` | camelCase singular | `turno` | Variables, nombres de archivo de un solo registro |
| `<Feature>` | PascalCase (= plural, para nombres de clase) | `Turnos` | `Pantalla<Feature>`, `Repositorio<Feature>Http` |
| `<feature>` | snake_case/plural, nombre de la carpeta | `turnos` | `lib/features/<feature>/`, nombres de archivo de listas |

## Paso a paso

### 1. Copiar los archivos de `docs/plantilla_feature/`

Mismo árbol que `lib/features/clientes/`, reemplazando los placeholders de la tabla de arriba y
sacando la extensión `.dart.txt` (es `.txt` a propósito, para que `flutter analyze` no intente
compilar la plantilla con los placeholders todavía adentro):

```
docs/plantilla_feature/dominio/entidad.dart.txt         -> lib/features/<feature>/dominio/<entidad>.dart
docs/plantilla_feature/dominio/repositorio.dart.txt     -> lib/features/<feature>/dominio/repositorio_<feature>.dart
docs/plantilla_feature/datos/entidad_dto.dart.txt       -> lib/features/<feature>/datos/<entidad>_dto.dart
docs/plantilla_feature/datos/fuente_remota.dart.txt     -> lib/features/<feature>/datos/fuente_remota_<feature>.dart
docs/plantilla_feature/datos/repositorio_http.dart.txt  -> lib/features/<feature>/datos/repositorio_<feature>_http.dart
docs/plantilla_feature/presentacion/proveedores/proveedores.dart.txt
                                                         -> lib/features/<feature>/presentacion/proveedores/<feature>_proveedores.dart
docs/plantilla_feature/presentacion/pantallas/pantalla_listado.dart.txt
                                                         -> lib/features/<feature>/presentacion/pantallas/pantalla_<feature>.dart
docs/plantilla_feature/presentacion/pantallas/formulario.dart.txt
                                                         -> lib/features/<feature>/presentacion/pantallas/formulario_<entidad>.dart
```

Si la entidad necesita widgets propios más allá de `FilaLista` (por ejemplo, una tarjeta con más de
2 líneas de datos), agregar `lib/features/<feature>/presentacion/widgets/tarjeta_<entidad>.dart` a
mano — no hay plantilla para eso, `tarjeta_cliente.dart` sirve de referencia.

### 2. Ajustar los campos reales de la entidad

Los templates traen `nombre` + `descripcion` + `activo` como campos de ejemplo. Casi ninguna entidad
real tiene exactamente esos — hay que ajustar `<entidad>.dart`, `<entidad>_dto.dart` (los 3 lugares:
`desdeJson`, `desdeDominio`, `aJson`, `aDominio`) y los campos del formulario en conjunto. Si la
entidad se relaciona con otra (como `Vehiculo` con `clienteId`), agregar ese campo y pasarlo como
parámetro del constructor de la pantalla, igual que `PantallaVehiculos({required this.clienteId})`.

### 3. Agregar las rutas a `lib/core/routing/rutas.dart`

Sección de nivel superior:

```dart
static const <feature> = '/<feature>';
static const <entidad>Nuevo = '/<feature>/nuevo';
static const <entidad>Editar = '/<feature>/:<entidad>Id/editar';
```

Anidada bajo otra entidad (ejemplo con un padre `clientes`, mismo patrón que `vehiculos`):

```dart
static const <feature> = '/clientes/:clienteId/<feature>';
static const <entidad>Nuevo = '/clientes/:clienteId/<feature>/nuevo';
static const <entidad>Editar = '/clientes/:clienteId/<feature>/:<entidad>Id/editar';
```

Si algún caller arma la ruta con un id (no navega a la lista pelada), agregar el helper — mismo
patrón que `rutaVehiculoEditar` en el archivo actual.

### 4. Registrar las rutas en `lib/core/routing/router.dart`

La pantalla de **listado** va dentro del `ShellRoute` (para heredar `AndamioAdaptativo`) si es una
sección de nivel superior, o como una ruta hija normal (fuera del shell, o anidada dentro de otra que
ya está en el shell) si es una pantalla intermedia como `vehiculos`/`servicios` — mirar cómo están
`Rutas.vehiculos` y `Rutas.servicios` en el archivo actual para copiar esa forma.

Los formularios (**nuevo**/**editar**) van **siempre fuera** del `ShellRoute`, a pantalla completa
(F7.6). El de editar necesita resolver la entidad por id para deep links — usar `ResolverPorId`
exactamente como en `Rutas.clienteEditar`:

```dart
GoRoute(
  path: Rutas.<entidad>Editar,
  pageBuilder: (context, state) {
    final id = _idDesdeRuta(state, '<entidad>Id');
    if (id == null) return _pagina(const PantallaNoEncontrada());
    return _pagina(
      ResolverPorId<<Entidad>>(
        extra: state.extra as <Entidad>?,
        leer: (ref) => ref.watch(<entidad>PorIdProvider(id)),
        reintentar: (ref) => ref.invalidate(<entidad>PorIdProvider(id)),
        constructor: (<entidad>) => Formulario<Entidad>(<entidad>: <entidad>),
      ),
    );
  },
),
```

No hay que olvidar los imports de las pantallas/proveedores nuevos arriba del archivo.

### 5. Si es una sección de nivel superior: agregar el destino de navegación

En `lib/core/routing/destinos.dart`, agregar una entrada a `destinosNavegacion`:

```dart
DestinoNavegacion(
  ruta: Rutas.<feature>,
  icono: Icons.<algo>_outlined,
  iconoSeleccionado: Icons.<algo>,
  etiqueta: '<Feature>',
),
```

Si es anidada (como `vehiculos`), este paso no aplica — se llega por navegación, no por el rail/barra.

### 6. Agregar el doble de prueba a `test/ayudas/dobles.dart`

Las plantillas de test (paso 8) importan `Repositorio<Feature>Falso` y `Repositorio<Feature>Vacio`
desde ahí — agregarlas siguiendo el patrón de `RepositorioClientesFalso`: `listar()` devuelve una
lista fija de 2+ elementos, `obtener(id)` busca por id en esa lista y **lanza si no lo encuentra**
(no `UnimplementedError` sin condición — ver la nota en `repositorio_test.dart.txt` sobre por qué
esto importa).

### 7. Copiar las plantillas de test

```
docs/plantilla_feature/test/repositorio_test.dart.txt  -> test/features/<feature>/repositorio_<feature>_test.dart
docs/plantilla_feature/test/proveedores_test.dart.txt  -> test/features/<feature>/<feature>_proveedores_test.dart
docs/plantilla_feature/test/pantalla_test.dart.txt     -> test/features/<feature>/pantalla_<feature>_test.dart
```

Sumar un test de comportamiento del formulario si tiene lógica propia que valga la pena probar
(validación no trivial, guardar que invalida la lista) — no hay plantilla para eso porque varía
demasiado entre formularios; usar `pantalla_clientes_test.dart` o el patrón de F9.31 (guardar
invalida la lista, de punta a punta) como referencia.

### 8. Barrels

Este proyecto **no tiene un barrel por feature** — cada archivo se importa directo desde donde se
usa (ver cómo `router.dart` importa `clientes_proveedores.dart` puntualmente). El único barrel real
es `lib/shared/shared.dart`: si el paso 1 agregó un widget nuevo y reusable a `/shared`, exportarlo
ahí. Si el widget es específico de esta feature, se queda en
`presentacion/widgets/` y no va en ningún barrel.

### 9. Verificar

```
flutter analyze
flutter test
```

`flutter analyze` puede quedar con un aviso de `directives_ordering` en los archivos copiados de la
plantilla: el orden de imports que trae ya alfabetizado es el que le queda bien a un nombre de
ejemplo, no a cualquiera — con el nombre real puede necesitar reordenarse. Es solo un `info`, no un
error; se corrige a mano siguiendo lo que indique el aviso.

## Checklist de "feature terminada"

- [ ] **Dominio**: entidad + interfaz de repositorio, sin ningún import de `dart:convert` ni de
      `package:http` ahí adentro.
- [ ] **Datos**: DTO con `desdeJson`/`desdeDominio`/`aJson`/`aDominio`, fuente remota, e
      implementación HTTP del repositorio — los 3 con los campos reales de la entidad, no los de
      ejemplo (`nombre`/`descripcion`) de la plantilla.
- [ ] **Presentación**: providers (`repositorio<Feature>Provider`, `<feature>Provider`,
      `<entidad>PorIdProvider`), pantalla de listado y formulario, usando `VistaAsync`, `FilaLista`,
      `SeccionFormulario`, `BotonPrimario`, `Notificador` y `ContenedorFormulario` — no un
      `ScaffoldMessenger` armado a mano ni un `EdgeInsets` literal fuera de `core/design_system/`.
- [ ] **Ruta**: constantes en `rutas.dart`, `GoRoute`s registrados en `router.dart` (listado dentro
      del shell o anidada según corresponda; formularios siempre fuera), deep link a "editar"
      probado con un id inexistente (debe mostrar error, no explotar) y uno no numérico (debe caer
      en 404, no lanzar).
- [ ] **Destino de navegación**: si es sección de nivel superior, entrada agregada a
      `destinosNavegacion`.
- [ ] **Tests de comportamiento**: doble agregado a `dobles.dart` con `obtener()` que realmente
      busca y lanza si no encuentra; tests de repositorio, providers y pantalla copiados y en verde;
      **nada de golden tests / `matchesGoldenFile`**.
- [ ] `flutter analyze` sin issues y `flutter test` en verde.
