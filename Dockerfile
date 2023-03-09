FROM node:18-alpine as builder

WORKDIR /app

COPY ./frontend/package*.json .

RUN npm pkg delete scripts.prepare
RUN HUSKY=0 npm ci --only=production --ignore-scripts

COPY ./frontend .

RUN npm run build

FROM node:18-alpine as PWA

WORKDIR /app

COPY ./backend/package*.json .

RUN npm pkg delete scripts.prepare
RUN HUSKY=0 npm ci --only=production

COPY ./backend .
COPY --from=0 /app/dist /app/dist

EXPOSE 3000

CMD ["npm", "start"]