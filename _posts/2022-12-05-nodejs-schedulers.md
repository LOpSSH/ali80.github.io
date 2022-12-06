---
layout: post
title: nodejs schedulers
date: 2022-12-04 20:17 +0330
tags: [nodejs]
---

## [node-schedule](https://github.com/node-schedule/node-schedule)
Node Schedule is a flexible cron-like and not-cron-like job scheduler for Node.js
While you can easily bend it to your will, if you only want to do something like "run this function every 5 minutes", toad-scheduler would be a better choice. But if you want to, say, "run this function at the :20 and :50 of every hour on the third Tuesday of every month," you'll find that Node Schedule suits your needs better. Additionally, Node Schedule has Windows support, unlike true cron, since the node runtime is now fully supported.
In case you need durable jobs that persist across restarts and lock system compatible with multi-node deployments, try **agenda** or **bree**.

## <a href="https://github.com/agenda/agenda">Agenda</a>
weakly dowloads: 105,070
- Minimal overhead. Agenda aims to keep its code base small.
- Mongo backed persistence layer.
- Promises based API.
- Scheduling with configurable priority, concurrency, repeating and persistence of job results.
- Scheduling via cron or human readable syntax.
- Event backed job queue that you can hook into.
- Agenda-rest: optional standalone REST API.
- Inversify-agenda - Some utilities for the development of agenda workers with Inversify.
- Agendash: optional standalone web-interface.

```ts
const mongoConnectionString = 'mongodb://127.0.0.1/agenda';

const agenda = new Agenda({ db: { address: mongoConnectionString } });

// Or override the default collection name:
// const agenda = new Agenda({db: {address: mongoConnectionString, collection: 'jobCollectionName'}});

// or pass additional connection options:
// const agenda = new Agenda({db: {address: mongoConnectionString, collection: 'jobCollectionName', options: {ssl: true}}});

// or pass in an existing mongodb-native MongoClient instance
// const agenda = new Agenda({mongo: myMongoClient});

agenda.define('delete old users', async job => {
  await User.remove({ lastLogIn: { $lt: twoDaysAgo } });
});

(async function () {
  // IIFE to give access to async/await
  await agenda.start();

  await agenda.every('3 minutes', 'delete old users');

  // Alternatively, you could also do:
  await agenda.every('*/3 * * * *', 'delete old users');
})();
```
```ts
agenda.define(
  'send email report',
  async job => {
    const { to } = job.attrs.data;
    await emailClient.send({
      to,
      from: 'example@example.com',
      subject: 'Email Report',
      body: '...'
    });
  },
  { priority: 'high', concurrency: 10 }
);

(async function () {
  await agenda.start();
  await agenda.schedule('in 20 minutes', 'send email report', { to: 'admin@example.com' });
})();
```

## <a href="https://www.npmjs.com/package/bull">Bull</a>
weakly dowloads: 495,918
- uses redis as db
-
[intro](https://optimalbits.github.io/bull/)
https://github.com/OptimalBits/bull/blob/develop/PATTERNS.md
https://github.com/OptimalBits/bull/blob/develop/REFERENCE.md


## <a href="What is BullMQ">BullMQ</a>
BullMQ is a Node.js library that implements a fast and robust queue system built on top of Redis that helps in resolving many modern age micro-services architectures.
The library is designed so that it will fulfill the following goals:
- Exactly once queue semantics, i.e., attempts to deliver every message exactly one time, but it will deliver at least once in the worst case scenario*.
- Easy to scale horizontally. Add more workers for processing jobs in parallel.
Consistent.
- High performant. Try to get the highest possible throughput from Redis by combining efficient .lua scripts and pipelining.


```ts
import { Queue, Worker, QueueEvents } from 'bullmq';
import { sleep } from "./utils/utils";

const queue = new Queue('main');
(async function() {
  const id1= await queue.add('add_user', { name: 'ali', age: 10 });
  const id2= await queue.add('add_task', { name: 'task1' });
  console.log(`id1=${id1.id}, id2=${id2.id}`);
})()

const worker1 = new Worker("main", async (job) => {
  if (job.name === 'add_user') {
    await sleep(2000);
    logger.info(`add_user ${JSON.stringify(job.data)}`);
    throw new Error("job failes when I throw");
  } else if (job.name === "add_task") {
    await sleep(2000);
    logger.info(`add_task ${JSON.stringify(job.data)}`);
  }
});

const queueEvents = new QueueEvents('main');
queueEvents.on('completed', ({ jobId }) => {
  console.log(`done ${jobId}`);
});

queueEvents.on('failed', ({ jobId, failedReason }: { jobId: string, failedReason: string }) => {
  console.error(`error painting ${jobId} `, failedReason);
});
```