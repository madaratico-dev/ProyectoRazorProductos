Clear-Host

function Actualizar-Path
{
    $MachinePath = [System.Environment]::GetEnvironmentVariable("Path","Machine")
    $UserPath = [System.Environment]::GetEnvironmentVariable("Path","User")

    $env:Path = "$MachinePath;$UserPath"
}

Write-Host "Verificando conexion a Internet..." -ForegroundColor Yellow

try
{
    Test-NetConnection github.com -Port 443 -InformationLevel Quiet | Out-Null

    if (!(Test-NetConnection github.com -Port 443 -InformationLevel Quiet))
    {
        Write-Host ""
        Write-Host "No hay conexion a Internet." -ForegroundColor Red
        Write-Host "Conectese a Internet y vuelva a ejecutar el instalador."
        exit
    }

    Write-Host "Conexion a Internet correcta." -ForegroundColor Green
}
catch
{
    Write-Host ""
    Write-Host "No fue posible verificar la conexion." -ForegroundColor Red
    exit
}

Write-Host ""

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "   INSTALADOR PROYECTO RAZOR PRODUCTOS" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "[1/6] Verificando Git..." -ForegroundColor Yellow

$git = Get-Command git -ErrorAction SilentlyContinue

if ($git)
{
    Write-Host ""
    Write-Host "Git encontrado correctamente." -ForegroundColor Green
}
else
{
    Write-Host ""
    Write-Host "Git NO esta instalado." -ForegroundColor Red
    Write-Host ""
    Write-Host "Descargando instalador de Git..." -ForegroundColor Yellow

    $GitInstaller = "$env:TEMP\Git-Installer.exe"

    Invoke-WebRequest `
        -Uri "https://github.com/git-for-windows/git/releases/latest/download/Git-64-bit.exe" `
        -OutFile $GitInstaller

    Write-Host ""
    Write-Host "Descarga completada." -ForegroundColor Green

    Start-Process $GitInstaller

    Write-Host ""
    Write-Host "==============================================" -ForegroundColor Cyan
    Write-Host "Instale Git y cuando termine presione ENTER." -ForegroundColor Cyan
    Write-Host "==============================================" -ForegroundColor Cyan

    Read-Host

    $git = Get-Command git -ErrorAction SilentlyContinue

	if ($git)
	{
    Actualizar-Path

    Write-Host ""
    Write-Host "Git instalado correctamente." -ForegroundColor Green
	}
	
    else
    {
        Write-Host ""
        Write-Host "Git aun no fue instalado." -ForegroundColor Red
        exit
    }
}

Write-Host ""
Read-Host "Presione ENTER para continuar"

Write-Host ""
Write-Host "[2/6] Verificando .NET 9 SDK..." -ForegroundColor Yellow

$dotnet = Get-Command dotnet -ErrorAction SilentlyContinue

if ($dotnet)
{
    Write-Host ""
    Write-Host ".NET SDK encontrado correctamente." -ForegroundColor Green
}
else
{
    Write-Host ""
    Write-Host ".NET SDK NO esta instalado." -ForegroundColor Red
    Write-Host ""
    Write-Host "Descargando instalador de .NET 9..." -ForegroundColor Yellow

    $DotNetInstaller = "$env:TEMP\dotnet-sdk-installer.exe"

    Invoke-WebRequest `
        -Uri "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.310/dotnet-sdk-9.0.310-win-x64.exe" `
        -OutFile $DotNetInstaller

    Write-Host ""
    Write-Host "Descarga completada." -ForegroundColor Green

    Start-Process $DotNetInstaller

    Write-Host ""
    Write-Host "==============================================" -ForegroundColor Cyan
    Write-Host "Instale .NET SDK y cuando termine presione ENTER." -ForegroundColor Cyan
    Write-Host "==============================================" -ForegroundColor Cyan

    Read-Host

    $dotnet = Get-Command dotnet -ErrorAction SilentlyContinue

    if ($dotnet)
{
    Actualizar-Path

    Write-Host ""
    Write-Host ".NET SDK instalado correctamente." -ForegroundColor Green
}
    else
    {
        Write-Host ""
        Write-Host ".NET SDK aun no fue instalado." -ForegroundColor Red
        exit
    }
}
Write-Host ""
Write-Host "[3/6] Verificando Visual Studio..." -ForegroundColor Yellow

$vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"

if (Test-Path $vswhere)
{
    $vs = & $vswhere -latest -products * -property installationPath

    if ($vs)
    {
        Write-Host ""
        Write-Host "Visual Studio encontrado." -ForegroundColor Green
    }
    else
    {
        Write-Host ""
        Write-Host "Visual Studio NO esta instalado." -ForegroundColor Red
        Write-Host ""
        Write-Host "Instalelo antes de continuar."
        exit
    }
}
else
{
    Write-Host ""
    Write-Host "No fue posible verificar Visual Studio." -ForegroundColor Yellow
    Write-Host "Instalelo si aun no lo tiene."
    exit
}

Write-Host ""
Write-Host "[4/6] Configuracion del proyecto..." -ForegroundColor Yellow
Write-Host ""

$RutaProyecto = Read-Host "Ingrese la carpeta donde desea instalar el proyecto"

if (!(Test-Path $RutaProyecto))
{
    New-Item -ItemType Directory -Path $RutaProyecto | Out-Null
}

Write-Host ""
Write-Host "La carpeta seleccionada es:" -ForegroundColor Cyan
Write-Host $RutaProyecto -ForegroundColor Green
Write-Host ""
Write-Host "[5/6] Clonando repositorio..." -ForegroundColor Yellow

Set-Location $RutaProyecto

$Repositorio = "https://github.com/madaratico-dev/ProyectoRazorProductos.git"

$NombreProyecto = "ProyectoRazorProductos"

$RutaRepositorio = Join-Path $RutaProyecto $NombreProyecto

if (Test-Path $RutaRepositorio)
{
    Write-Host ""
    Write-Host "El proyecto ya existe." -ForegroundColor Yellow
    Write-Host "Actualizando repositorio..." -ForegroundColor Yellow

    Set-Location $RutaRepositorio

    git pull

    if ($LASTEXITCODE -eq 0)
    {
        Write-Host ""
        Write-Host "Repositorio actualizado correctamente." -ForegroundColor Green
    }
    else
    {
        Write-Host ""
        Write-Host "No fue posible actualizar el repositorio." -ForegroundColor Red
        exit
    }
}
else
{
    git clone $Repositorio

    if ($LASTEXITCODE -eq 0)
    {
        Write-Host ""
        Write-Host "Repositorio clonado correctamente." -ForegroundColor Green
    }
    else
    {
        Write-Host ""
        Write-Host "Error al clonar el repositorio." -ForegroundColor Red
        exit
    }
}

Write-Host ""
Write-Host "[6/6] Restaurando paquetes..." -ForegroundColor Yellow

Set-Location $RutaRepositorio

dotnet restore

if ($LASTEXITCODE -eq 0)
{
    Write-Host ""
    Write-Host "Paquetes restaurados correctamente." -ForegroundColor Green
}
else
{
    Write-Host ""
    Write-Host "Error al restaurar los paquetes." -ForegroundColor Red
    exit
}
Write-Host ""
Write-Host "[7/7] Compilando proyecto..." -ForegroundColor Yellow

dotnet build

if ($LASTEXITCODE -eq 0)
{
    Write-Host ""
    Write-Host "Proyecto compilado correctamente." -ForegroundColor Green
}
else
{
    Write-Host ""
    Write-Host "Error al compilar el proyecto." -ForegroundColor Red
    exit
}