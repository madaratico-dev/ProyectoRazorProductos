function MostrarMenu
{
    Clear-Host

    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "      GESTOR DEL PROYECTO" -ForegroundColor Cyan
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host ""

Write-Host "1. DESCARGAR ULTIMOS CAMBIOS"
Write-Host "2. CREAR NUEVA RAMA"
Write-Host "3. CAMBIAR DE RAMA"
Write-Host "4. VER RAMAS"
Write-Host "5. VER ESTADO"
Write-Host "6. GUARDAR CAMBIOS (ADD + COMMIT + PUSH)"
Write-Host "7. RECONSTRUIR PROYECTO DOCKER"
Write-Host "8. EJECUTAR PRUEBAS"
Write-Host "9. EJECUTAR PROYECTO"
Write-Host "10. ABRIR VISUAL STUDIO"
Write-Host "11. SALIR"
}

while ($true)
{
    MostrarMenu

    $opcion = Read-Host "SELECCIONE UNA OPCION"

    Write-Host ""
    Write-Host "OPCION SELECCIONADA: $opcion" -ForegroundColor Yellow

    switch ($opcion)
    {
"1"
{
    Write-Host ""
    Write-Host "VERIFICANDO CAMBIOS LOCALES..." -ForegroundColor Yellow
    Write-Host ""

    $Cambios = git status --porcelain

    if ($Cambios)
    {
        Write-Host ""
        Write-Host "EXISTEN CAMBIOS SIN GUARDAR." -ForegroundColor Yellow
        Write-Host "UTILICE LA OPCION 6 PARA GUARDAR LOS CAMBIOS ANTES DE ACTUALIZAR." -ForegroundColor Yellow
        break
    }

    Write-Host ""
    Write-Host "DESCARGANDO ULTIMOS CAMBIOS..." -ForegroundColor Yellow
    Write-Host ""

    git pull --rebase

    if ($LASTEXITCODE -eq 0)
    {
        Write-Host ""
        Write-Host "PROYECTO ACTUALIZADO CORRECTAMENTE." -ForegroundColor Green
    }
    else
    {
        Write-Host ""
        Write-Host "OCURRIO UN ERROR AL ACTUALIZAR EL PROYECTO." -ForegroundColor Red
    }
}

   "2"
{
    Write-Host ""

    $NombreRama = Read-Host "INGRESE EL NOMBRE DE LA NUEVA RAMA"

    if ([string]::IsNullOrWhiteSpace($NombreRama))
    {
        Write-Host ""
        Write-Host "EL NOMBRE DE LA RAMA NO PUEDE ESTAR VACIO." -ForegroundColor Red
        break
    }

    # LIMPIAR EL NOMBRE DE LA RAMA
    $NombreRama = $NombreRama.Trim()

    $NombreRama = $NombreRama `
        -replace '[áàäâ]','a' `
        -replace '[éèëê]','e' `
        -replace '[íìïî]','i' `
        -replace '[óòöô]','o' `
        -replace '[úùüû]','u' `
        -replace '[ñ]','n' `
        -replace '[ÁÀÄÂ]','A' `
        -replace '[ÉÈËÊ]','E' `
        -replace '[ÍÌÏÎ]','I' `
        -replace '[ÓÒÖÔ]','O' `
        -replace '[ÚÙÜÛ]','U' `
        -replace '[Ñ]','N'

    # REEMPLAZAR ESPACIOS POR GUIONES
    $NombreRama = $NombreRama -replace '\s+','-'

    # ELIMINAR CARACTERES INVALIDOS
    $NombreRama = $NombreRama -replace '[^a-zA-Z0-9/_-]',''

    # CONVERTIR A MINUSCULAS
    $NombreRama = $NombreRama.ToLower()

    Write-Host ""
    Write-Host "NOMBRE FINAL DE LA RAMA: $NombreRama" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "CREANDO RAMA..." -ForegroundColor Yellow
    Write-Host ""

    git checkout -b $NombreRama

    if ($LASTEXITCODE -ne 0)
    {
        Write-Host ""
        Write-Host "NO SE PUDO CREAR LA RAMA." -ForegroundColor Red
        break
    }

    git push -u origin $NombreRama

    if ($LASTEXITCODE -eq 0)
    {
        Write-Host ""
        Write-Host "RAMA CREADA Y SUBIDA CORRECTAMENTE." -ForegroundColor Green
    }
    else
    {
        Write-Host ""
        Write-Host "LA RAMA SE CREO LOCALMENTE, PERO NO SE PUDO SUBIR A GITHUB." -ForegroundColor Red
    }
}
	"3"
{
    Write-Host ""
    Write-Host "ACTUALIZANDO INFORMACION..." -ForegroundColor Yellow
    Write-Host ""

    git fetch

    Write-Host ""
    Write-Host "RAMAS DISPONIBLES:" -ForegroundColor Cyan
    Write-Host ""

    git branch

    Write-Host ""

    $NombreRama = Read-Host "INGRESE EL NOMBRE DE LA RAMA"

    if ([string]::IsNullOrWhiteSpace($NombreRama))
    {
        Write-Host ""
        Write-Host "EL NOMBRE DE LA RAMA NO PUEDE ESTAR VACIO." -ForegroundColor Red
        break
    }

    $Cambios = git status --porcelain

    if ($Cambios)
    {
        Write-Host ""
        Write-Host "EXISTEN CAMBIOS SIN GUARDAR." -ForegroundColor Yellow
        Write-Host "UTILICE LA OPCION 6 PARA GUARDARLOS ANTES DE CAMBIAR DE RAMA." -ForegroundColor Yellow
        break
    }

    Write-Host ""
    Write-Host "CAMBIANDO DE RAMA..." -ForegroundColor Yellow
    Write-Host ""

    git checkout $NombreRama

    if ($LASTEXITCODE -eq 0)
    {
        Write-Host ""
        Write-Host "SE CAMBIO A LA RAMA CORRECTAMENTE." -ForegroundColor Green
    }
    else
    {
        Write-Host ""
        Write-Host "NO SE PUDO CAMBIAR DE RAMA." -ForegroundColor Red
    }
}

"4"
{
    Write-Host ""
    Write-Host "ACTUALIZANDO INFORMACION..." -ForegroundColor Yellow
    Write-Host ""

    git fetch

    Write-Host ""
    Write-Host "RAMAS DISPONIBLES:" -ForegroundColor Cyan
    Write-Host ""

git branch
}

   "5"
{
    Write-Host ""
    Write-Host "ESTADO DEL REPOSITORIO" -ForegroundColor Cyan
    Write-Host ""

    git status
}

"6"
{
    Write-Host ""
    Write-Host "PREPARANDO CAMBIOS..." -ForegroundColor Yellow
    Write-Host ""

    git add .

    if ($LASTEXITCODE -ne 0)
    {
        Write-Host ""
        Write-Host "NO SE PUDIERON AGREGAR LOS CAMBIOS." -ForegroundColor Red
        break
    }

    $Cambios = git status --porcelain

    if ([string]::IsNullOrWhiteSpace($Cambios))
    {
        Write-Host ""
        Write-Host "NO EXISTEN CAMBIOS PARA REALIZAR EL COMMIT." -ForegroundColor Yellow
        break
    }

    Write-Host ""
    $Mensaje = Read-Host "INGRESE EL MENSAJE DEL COMMIT"

    if ([string]::IsNullOrWhiteSpace($Mensaje))
    {
        Write-Host ""
        Write-Host "EL MENSAJE DEL COMMIT NO PUEDE ESTAR VACIO." -ForegroundColor Red
        break
    }

    Write-Host ""
    Write-Host "CREANDO COMMIT..." -ForegroundColor Yellow
    Write-Host ""

    git commit -m "$Mensaje"

    if ($LASTEXITCODE -ne 0)
    {
        Write-Host ""
        Write-Host "NO SE PUDO CREAR EL COMMIT." -ForegroundColor Red
        break
    }

    $RamaActual = git branch --show-current

    Write-Host ""
    Write-Host "SUBIENDO CAMBIOS A GITHUB..." -ForegroundColor Yellow
    Write-Host ""

    git push origin $RamaActual

    if ($LASTEXITCODE -eq 0)
    {
        Write-Host ""
        Write-Host "COMMIT Y PUSH REALIZADOS CORRECTAMENTE." -ForegroundColor Green
    }
    else
    {
        Write-Host ""
        Write-Host "EL COMMIT SE CREO, PERO OCURRIO UN ERROR AL SUBIR LOS CAMBIOS." -ForegroundColor Red
    }
}

"7"
{
    Write-Host ""
    Write-Host "RECONSTRUYENDO EL PROYECTO..." -ForegroundColor Yellow
    Write-Host ""

    Push-Location (Join-Path $PSScriptRoot "..")

    Write-Host "DETENIENDO CONTENEDORES..." -ForegroundColor Cyan
    docker compose down --remove-orphans

    Write-Host ""
    Write-Host "ELIMINANDO CONTENEDORES..." -ForegroundColor Cyan

    docker rm -f sqlserver 2>$null | Out-Null
    docker rm -f proyectorazorproductos 2>$null | Out-Null

    Write-Host ""
    Write-Host "RECONSTRUYENDO EL PROYECTO..." -ForegroundColor Cyan

    docker compose up --build -d

    if ($LASTEXITCODE -eq 0)
    {
        Write-Host ""
        Write-Host "ESPERANDO QUE LA APLICACION INICIE..." -ForegroundColor Cyan

        Start-Sleep -Seconds 15

        Write-Host ""
        Write-Host "VERIFICANDO CONTENEDORES..." -ForegroundColor Cyan
        docker ps

        Write-Host ""
        Write-Host "ABRIENDO NAVEGADOR..." -ForegroundColor Cyan
        Start-Process "http://localhost:8080"

        Write-Host ""
        Write-Host "PROYECTO RECONSTRUIDO CORRECTAMENTE." -ForegroundColor Green
    }
    else
    {
        Write-Host ""
        Write-Host "ERROR AL RECONSTRUIR EL PROYECTO." -ForegroundColor Red
    }

    Pop-Location
}
"8"
{
    Write-Host ""

$Tests = Join-Path $PSScriptRoot "..\Tests\Tests.csproj"

dotnet test $Tests
}
"9"
{
    Write-Host ""

    Write-Host "ABRIENDO LA APLICACION..." -ForegroundColor Yellow

    Start-Process "http://localhost:8080"

    Write-Host ""
    Write-Host "APLICACION ABIERTA." -ForegroundColor Green
}
"10"
{
    Write-Host ""

    Start-Process "..\ProyectoRazorProductos.sln"
}
"11"
{
    break
}

default
{
    Write-Host ""
    Write-Host "OPCION NO VALIDA." -ForegroundColor Red
}

}   # CIERRA EL SWITCH

Write-Host ""
Read-Host "PRESIONE ENTER PARA CONTINUAR"

}   # CIERRA EL WHILE