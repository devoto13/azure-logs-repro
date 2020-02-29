FROM node:13.8.0-alpine3.10

COPY index.js index.js

CMD ["node", "index.js"]
