# Proyecto Razor Productos

Aplicación web desarrollada con ASP.NET Core MVC y Entity Framework Core para la gestión de productos.

---

# Requisitos

- Windows 10 u 11
- Visual Studio 2022 (con ASP.NET y .NET Desktop Development)
- Conexión a Internet

> **Nota:** Git y .NET SDK son verificados automáticamente por el instalador.

---

# Instalación automática (Recomendada)

1. Descargue el repositorio o clónelo desde GitHub.

2. Abra la carpeta:

```
Tools
```

3. Ejecute:

```
InstalarProyecto.bat
```

El instalador realizará automáticamente las siguientes tareas:

- Verifica la conexión a Internet.
- Verifica si Git está instalado.
- Descarga Git si no está instalado.
- Verifica si .NET 9 SDK está instalado.
- Descarga .NET SDK si no está instalado.
- Verifica Visual Studio 2022.
- Solicita la carpeta de instalación.
- Clona o actualiza el repositorio.
- Ejecuta:

```
dotnet restore
```

- Compila el proyecto mediante:

```
dotnet build
```

Al finalizar el proyecto quedará listo para abrirse desde Visual Studio.

---

# Instalación manual

## Clonar el repositorio

```bash
git clone https://github.com/madaratico-dev/ProyectoRazorProductos.git
```

## Entrar al proyecto

```bash
cd ProyectoRazorProductos
```

## Restaurar dependencias

```bash
dotnet restore
```

## Compilar

```bash
dotnet build
```

## Ejecutar

```bash
dotnet run
```

---

# Ejecutar pruebas

```bash
dotnet test
```

---

# Comandos Git

## Obtener cambios

```bash
git pull
```

## Crear una rama

```bash
git checkout -b nombre-rama
```

## Cambiar de rama

```bash
git checkout nombre-rama
```

## Ver estado

```bash
git status
```

## Agregar cambios

```bash
git add .
```

## Crear un commit

```bash
git commit -m "Descripción del cambio"
```

## Subir cambios

```bash
git push origin nombre-rama
```

---

# Tecnologías utilizadas

- ASP.NET Core MVC (.NET 9)
- Entity Framework Core
- SQL Server
- xUnit
- Git
- GitHub

---

# Repositorio

https://github.com/madaratico-dev/ProyectoRazorProductos
