---
layout: post
title: CRUD with mongodb, express, zod and jest
date: 2022-11-22 09:49 +0330
tags:
- ts
- typescript
categories: []
---
ref: https://github.com/CodingGarden/intro-to-typescript.git
## startup template
[starter template from coding garden](https://github.com/w3cj/express-api-starter-ts)
```
npx create-express-api --typescript --directory my-express-app
```


```json
"dev1": "cross-env MONGO_URL= NODE_ENV=dev nodemon src/index.ts",
"dev2": "cross-env MONGO_URL=mongodb://localhost:27017/test NODE_ENV=dev nodemon src/index.ts",
"dev3": "cross-env MONGO_URL=mongodb://localhost:27017/test NODE_ENV=dev USERID=aliId nodemon src/index.ts",
"dev5": "cross-env MONGO_URL= NODE_ENV=dev tsnd --exit-child --transpile-only --inspect=4321 src/index.ts",
```

## jest
### jest does not close properly after test completes
you should close mongo connection after test
```json
setupFilesAfterEnv: ['<rootDir>/src/setupFilesAfterEnv.ts'],
```
{:file=.jest.config.js}

```ts
import { client } from './db';

global.afterAll(async () => {
  client.close();
});
```
{:file=setupFilesAfterEnv.ts}

```ts
import { MongoClient } from 'mongodb';

const { MONGO_URL = 'mongodb://localhost/todo-api' } = process.env;

export const client = new MongoClient(MONGO_URL);
export const db = client.db();
```
{:file=db.ts}

```ts
import { NextFunction, Request, Response } from 'express';
import { ZodError } from 'zod';

import ErrorResponse from './interfaces/ErrorResponse';
import RequestValidators from './interfaces/RequestValidators';

export function notFound(req: Request, res: Response, next: NextFunction) {
  res.status(404);
  const error = new Error(`🔍 - Not Found - ${req.originalUrl}`);
  next(error);
}

// eslint-disable-next-line @typescript-eslint/no-unused-vars
export function errorHandler(err: Error, req: Request, res: Response<ErrorResponse>, next: NextFunction) {
  const statusCode = res.statusCode !== 200 ? res.statusCode : 500;
  res.status(statusCode);
  res.json({
    message: err.message,
    stack: process.env.NODE_ENV === 'production' ? '🥞' : err.stack,
  });
}


export function validateRequest(validators: RequestValidators) {
  return (async (req: Request, res: Response, next: NextFunction) => {
    try {
      if (validators.body) {
        req.body = await validators.body.parseAsync(req.body);
      }
      if (validators.params) {
        req.params = await validators.params.parseAsync(req.params);
      }
      if (validators.query) {
        req.query = await validators.query.parseAsync(req.query);
      }
      next();
    } catch (error) {
      if (error instanceof ZodError) {
        res.status(422);
      }
      next(error);
    }
  });
}
```
{:file=middlewares.ts}

## zod mongo model
```ts
import { WithId } from 'mongodb';
import * as z from 'zod';
import { db } from '../../db';


export const Todo = z.object({
  content: z.string().min(1),
  done: z.boolean().default(false),
});

export type Todo = z.infer<typeof Todo>;
export type TodoWithId = WithId<Todo>;
export const Todos = db.collection<Todo>('todos');
```

