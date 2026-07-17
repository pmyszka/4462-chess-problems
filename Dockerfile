FROM node:18-alpine AS build
WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm start

FROM node:18-alpine AS runtime
WORKDIR /app

RUN npm install -g serve

COPY --from=build /app/index.html ./index.html
COPY --from=build /app/dist ./dist
COPY --from=build /app/chessboard/img ./chessboard/img

EXPOSE 80

CMD ["serve", "-s", ".", "-l", "80"]
