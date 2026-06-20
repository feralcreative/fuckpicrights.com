# --- build stage: compile SCSS -> style.css ---
FROM node:20-alpine AS build
WORKDIR /app
COPY package.json ./
RUN npm install --no-audit --no-fund
COPY scss/ ./scss/
RUN npx sass scss/main.scss style.css --style=compressed --no-source-map

# --- runtime stage: static nginx ---
FROM nginx:1.27-alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY index.html robots.txt /usr/share/nginx/html/
COPY assets/ /usr/share/nginx/html/assets/
COPY --from=build /app/style.css /usr/share/nginx/html/style.css
EXPOSE 80
