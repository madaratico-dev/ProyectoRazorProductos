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
    Write-Host "6. AGREGAR CAMBIOS"
    Write-Host "7. CREAR COMMIT"
    Write-Host "8. SUBIR CAMBIOS"
    Write-Host "9. COMPILAR PROYECTO"
    Write-Host "10. EJECUTAR PRUEBAS"
    Write-Host "11. EJECUTAR PROYECTO"
    Write-Host "12. ABRIR VISUAL STUDIO"
    Write-Host "13. SALIR"
    Write-Host ""
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
        Write-Host "DESCARGANDO ULTIMOS CAMBIOS..." -ForegroundColor Yellow
        Write-Host ""

        git pull

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
        }
        else
        {
            Write-Host ""
            Write-Host "CREANDO RAMA..." -ForegroundColor Yellow
            Write-Host ""

            git checkout -b $NombreRama

            if ($LASTEXITCODE -eq 0)
            {
                git push -u origin $NombreRama

                if ($LASTEXITCODE -eq 0)
                {
                    Write-Host ""
                    Write-Host "RAMA CREADA CORRECTAMENTE." -ForegroundColor Green
                }
                else
                {
                    Write-Host ""
                    Write-Host "LA RAMA SE CREO LOCALMENTE, PERO NO SE PUDO SUBIR A GITHUB." -ForegroundColor Red
                }
            }
            else
            {
                Write-Host ""
                Write-Host "NO SE PUDO CREAR LA RAMA." -ForegroundColor Red
            }
        }
    }
	"3"
{
    Write-Host ""
    Write-Host "RAMAS DISPONIBLES:" -ForegroundColor Cyan
    Write-Host ""

    git branch -av

    Write-Host ""

    $NombreRama = Read-Host "INGRESE EL NOMBRE DE LA RAMA"

    if ([string]::IsNullOrWhiteSpace($NombreRama))
    {
        Write-Host ""
        Write-Host "EL NOMBRE DE LA RAMA NO PUEDE ESTAR VACIO." -ForegroundColor Red
    }
    else
    {
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

    git branch -av
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
    Write-Host "AGREGANDO CAMBIOS..." -ForegroundColor Yellow
    Write-Host ""

    git add .

    if ($LASTEXITCODE -eq 0)
    {
        Write-Host ""
        Write-Host "CAMBIOS AGREGADOS CORRECTAMENTE." -ForegroundColor Green
    }
    else
    {
        Write-Host ""
        Write-Host "NO SE PUDIERON AGREGAR LOS CAMBIOS." -ForegroundColor Red
    }
}
"7"
{
    Write-Host ""

    $Mensaje = Read-Host "INGRESE EL MENSAJE DEL COMMIT"

    if([string]::IsNullOrWhiteSpace($Mensaje))
    {
        Write-Host ""
        Write-Host "EL MENSAJE NO PUEDE ESTAR VACIO." -ForegroundColor Red
    }
    else
    {
        git commit -m "$Mensaje"

        if($LASTEXITCODE -eq 0)
        {
            Write-Host ""
            Write-Host "COMMIT CREADO CORRECTAMENTE." -ForegroundColor Green
        }
        else
        {
            Write-Host ""
            Write-Host "NO SE PUDO CREAR EL COMMIT." -ForegroundColor Red
        }
    }
}
"8"
{
    Write-Host ""

    $RamaActual = git branch --show-current

    Write-Host "SUBIENDO CAMBIOS A $RamaActual..." -ForegroundColor Yellow
    Write-Host ""

    git push origin $RamaActual

    if($LASTEXITCODE -eq 0)
    {
        Write-Host ""
        Write-Host "CAMBIOS SUBIDOS CORRECTAMENTE." -ForegroundColor Green
    }
    else
    {
        Write-Host ""
        Write-Host "NO SE PUDIERON SUBIR LOS CAMBIOS." -ForegroundColor Red
    }
}
"9"
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
"10"
{
    Write-Host ""

$Tests = Join-Path $PSScriptRoot "..\Tests\Tests.csproj"

dotnet test $Tests
}
"11"
{
    Write-Host ""
    Write-Host "INICIANDO PROYECTO..." -ForegroundColor Yellow
    Write-Host ""

    $Proyecto = Join-Path $PSScriptRoot "..\ProyectoRazorProductos.csproj"

    Start-Job -ScriptBlock {
        param($Proyecto)
        dotnet run --project $Proyecto
    } -ArgumentList $Proyecto | Out-Null

    Start-Sleep -Seconds 5

    Start-Process "http://localhost:5250"

    Write-Host ""
    Write-Host "PROYECTO EJECUTANDOSE EN EL NAVEGADOR." -ForegroundColor Green
}
"12"
{
    Write-Host ""

    Start-Process "..\ProyectoRazorProductos.sln"
}
"13"
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