# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

ReLoot Backend - это RESTful API сервер, построенный на современном стеке:
- **Node.js 20+** - Runtime окружение
- **TypeScript** - Типизированный JavaScript
- **NestJS** - Enterprise-grade Node.js framework
- **PostgreSQL** - Реляционная база данных
- **Prisma** - Next-generation ORM
- **JWT** - Аутентификация и авторизация
- **Swagger** - API документация

## Common Commands

### Development

```bash
# Установка зависимостей
npm install

# Запуск БД через Docker
docker-compose -f docker-compose.dev.yml up -d

# Генерация Prisma Client
npx prisma generate

# Создание миграции
npx prisma migrate dev --name <migration_name>

# Применение миграций
npx prisma migrate deploy

# Запуск в режиме разработки (с hot-reload)
npm run start:dev

# Запуск в обычном режиме
npm run start

# Запуск в production режиме
npm run start:prod
```

### Database Management

```bash
# Открыть Prisma Studio (GUI для БД)
npx prisma studio

# Сбросить БД (удалить все данные)
npx prisma migrate reset

# Применить схему в БД без миграций (для разработки)
npx prisma db push

# Синхронизировать схему с существующей БД
npx prisma db pull
```

### Testing

```bash
# Запуск unit тестов
npm run test

# Запуск тестов в watch режиме
npm run test:watch

# Запуск e2e тестов
npm run test:e2e

# Покрытие кода тестами
npm run test:cov
```

### Building & Linting

```bash
# Сборка проекта
npm run build

# Линтинг кода
npm run lint

# Форматирование кода
npm run format
```

### Docker

```bash
# Запуск всего стека (PostgreSQL + App)
docker-compose up -d

# Запуск только PostgreSQL (для локальной разработки)
docker-compose -f docker-compose.dev.yml up -d

# Остановка контейнеров
docker-compose down

# Пересборка образов
docker-compose up -d --build

# Просмотр логов
docker-compose logs -f app
```

## Architecture

### Directory Structure

```
src/
├── auth/              # Модуль аутентификации
│   ├── dto/          # Data Transfer Objects
│   ├── guards/       # JWT Guards
│   ├── strategies/   # Passport strategies
│   ├── auth.controller.ts
│   ├── auth.service.ts
│   └── auth.module.ts
│
├── users/            # Модуль пользователей
│   ├── dto/         # DTOs для пользователей
│   ├── users.controller.ts
│   ├── users.service.ts
│   └── users.module.ts
│
├── prisma/          # Prisma модуль
│   ├── prisma.service.ts
│   └── prisma.module.ts
│
├── app.module.ts    # Корневой модуль
└── main.ts          # Точка входа приложения

prisma/
└── schema.prisma    # Схема базы данных
```

### Key Patterns

1. **Module-based Architecture**: Каждая функциональная область инкапсулирована в отдельный модуль
2. **Dependency Injection**: Все зависимости инжектятся через конструктор
3. **DTO Validation**: Используется class-validator для автоматической валидации входящих данных
4. **Global Pipes**: ValidationPipe настроен глобально в main.ts
5. **Prisma Service**: PrismaService является глобальным и доступен во всех модулях
6. **JWT Authentication**: Защита эндпоинтов через JwtAuthGuard декоратор

### Database Models

Базовые модели включают:
- **User** - Пользователи с ролями (USER, ADMIN, MODERATOR)
- **Profile** - Расширенная информация о пользователе (связь 1:1)
- **Post** - Посты пользователей (связь many-to-one)
- **Category** - Категории для постов (связь many-to-many)

### Environment Variables

Обязательные переменные окружения (см. `.env.example`):
- `DATABASE_URL` - PostgreSQL connection string
- `PORT` - Порт приложения (по умолчанию 3000)
- `NODE_ENV` - Окружение (development/production)
- `JWT_SECRET` - Секретный ключ для JWT
- `JWT_EXPIRES_IN` - Время жизни токена
- `BCRYPT_ROUNDS` - Количество раундов для bcrypt хеширования

## API Documentation

После запуска приложения, Swagger документация доступна по адресу:
```
http://localhost:3000/api/docs
```

### Main Endpoints

**Authentication:**
- `POST /auth/register` - Регистрация нового пользователя
- `POST /auth/login` - Вход в систему
- `GET /auth/profile` - Получить профиль (требует JWT)

**Users:**
- `GET /users` - Список пользователей (с пагинацией)
- `GET /users/:id` - Получить пользователя по ID
- `POST /users` - Создать пользователя
- `PATCH /users/:id` - Обновить пользователя
- `DELETE /users/:id` - Удалить пользователя

## Development Guidelines

### Adding New Features

1. **Create Module**: Используйте NestJS CLI
   ```bash
   nest g module feature-name
   nest g service feature-name
   nest g controller feature-name
   ```

2. **Define Prisma Models**: Добавьте модели в `prisma/schema.prisma`
   ```bash
   npx prisma migrate dev --name add_feature
   ```

3. **Create DTOs**: Добавьте DTO с валидацией в `feature-name/dto/`

4. **Implement Business Logic**: В сервисах используйте PrismaService

5. **Add Guards**: Используйте `@UseGuards(JwtAuthGuard)` для защищенных эндпоинтов

6. **Document API**: Используйте декораторы Swagger (@ApiTags, @ApiOperation, и т.д.)

### Code Style

- Используйте TypeScript strict mode
- Следуйте ESLint правилам проекта
- Все публичные методы должны иметь явные типы возвращаемых значений
- Используйте async/await вместо промисов
- Обрабатывайте ошибки через NestJS exceptions (NotFoundException, ConflictException, и т.д.)

### Security Best Practices

- Никогда не возвращайте пароли в API ответах
- Используйте JWT для аутентификации
- Валидируйте все входящие данные через class-validator
- Используйте bcrypt для хеширования паролей
- Настройте CORS в соответствии с вашими требованиями

## Troubleshooting

### Проблемы с Prisma

```bash
# Если Prisma Client не генерируется
npm run prisma:generate

# Если миграции не применяются
npx prisma migrate reset
npx prisma migrate deploy

# Если схема не синхронизируется
npx prisma db push
```

### Проблемы с PostgreSQL

```bash
# Проверить статус контейнера
docker ps

# Пересоздать контейнер БД
docker-compose -f docker-compose.dev.yml down -v
docker-compose -f docker-compose.dev.yml up -d

# Подключиться к БД
docker exec -it reloot-postgres-dev psql -U postgres -d reloot_db
```

### Port Already in Use

```bash
# Найти процесс на порту 3000
lsof -i :3000

# Убить процесс
kill -9 <PID>
```

## Notes

- При добавлении новых зависимостей, не забудьте обновить Dockerfile
- После изменений в schema.prisma всегда запускайте `npx prisma generate`
- Используйте транзакции Prisma для операций, затрагивающих несколько таблиц
- Для production используйте переменные окружения, не hardcode значения