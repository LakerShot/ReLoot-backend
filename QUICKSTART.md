# 🚀 Быстрый Старт ReLoot Backend

## Предварительные требования
- Node.js 20+
- npm 10+
- Docker и Docker Compose

## Запуск за 5 минут

### 1. Установка зависимостей
```bash
npm install
```

### 2. Настройка окружения
```bash
# .env файл уже настроен с базовыми значениями
# Для production измените JWT_SECRET!
```

### 3. Запуск PostgreSQL
```bash
docker-compose -f docker-compose.dev.yml up -d
```

### 4. Применение миграций
```bash
npx prisma migrate deploy
# или для разработки:
# npx prisma migrate dev
```

### 5. Запуск приложения
```bash
npm run start:dev
```

## ✅ Проверка работы

Откройте в браузере:
- API: http://localhost:3000
- Swagger UI: http://localhost:3000/api/docs
- Prisma Studio: `npx prisma studio`

## 🧪 Тестирование API

### Регистрация пользователя
```bash
curl -X POST http://localhost:3000/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123",
    "firstName": "Test",
    "lastName": "User"
  }'
```

### Вход в систему
```bash
curl -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'
```

### Получение профиля (с токеном)
```bash
# Замените YOUR_TOKEN на токен из предыдущего запроса
curl -X GET http://localhost:3000/auth/profile \
  -H "Authorization: Bearer YOUR_TOKEN"
```

## 📚 Дополнительные ресурсы

- [Полная документация](./README.md)
- [WARP руководство](./WARP.md)
- [Swagger UI](http://localhost:3000/api/docs) - после запуска приложения

## 🐛 Проблемы?

### Порт занят
```bash
lsof -ti :3000 | xargs kill -9
```

### Проблемы с БД
```bash
docker-compose -f docker-compose.dev.yml down -v
docker-compose -f docker-compose.dev.yml up -d
npx prisma migrate reset
```

### Проблемы с Prisma
```bash
npx prisma generate
npx prisma migrate dev
```