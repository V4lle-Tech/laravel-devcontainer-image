# Laravel DevContainer Image

Imagen Docker pre-construida para desarrollo Laravel optimizada para uso con Coder workspaces.

## Contenido

- **PHP 8.4** con extensiones para Laravel:
  - pgsql, sqlite3, gd, curl, imap, mbstring, xml, zip
  - bcmath, soap, intl, readline, ldap
  - msgpack, igbinary, redis, pcov, xdebug
- **Composer** (ultima version)
- **Node.js 20** con npm
- **Bun** runtime
- **Laravel Installer**
- **Vue CLI** y **create-vite**
- **PostgreSQL client** y **Redis tools**
- **MinIO Client (mc)**

## Uso

### Pull de la imagen

```bash
docker pull ghcr.io/v4lle-tech/laravel-devcontainer:latest
```

### En devcontainer.json

```json
{
  "name": "Laravel Development",
  "image": "ghcr.io/v4lle-tech/laravel-devcontainer:latest",
  "workspaceFolder": "/workspaces",
  "remoteUser": "coder"
}
```

### En Coder template

```hcl
container {
  image = "ghcr.io/v4lle-tech/laravel-devcontainer:latest"
}
```

## Usuario

La imagen incluye el usuario `coder` con UID 1000 y permisos sudo sin password.

## Puertos

- **8000**: Laravel development server
- **5173**: Vite dev server

## Build local

```bash
docker build -t laravel-devcontainer .
```

## Versiones

Las versiones se publican automaticamente cuando se crea un tag:

```bash
git tag v1.0.0
git push origin v1.0.0
```

## Licencia

MIT
