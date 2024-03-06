'use strict';

const fs = require('fs');
const config = require('wild-config');
const Queue = require('bull');
const Redis = require('ioredis');
const redis = new Redis(config.dbs.redis);
const notifyQueue = new Queue('notify', { redis: config.dbs.redis });

const zExpungeScript = fs.readFileSync(__dirname + '/lua/z-expunge.lua', 'utf-8');
const zSetScript = fs.readFileSync(__dirname + '/lua/z-set.lua', 'utf-8');
const zGetScript = fs.readFileSync(__dirname + '/lua/z-get.lua', 'utf-8');
const zGetByUidScript = fs.readFileSync(__dirname + '/lua/z-get-by-uid.lua', 'utf-8');
const zGetMailboxIdScript = fs.readFileSync(__dirname + '/lua/z-get-mailbox-id.lua', 'utf-8');
const zGetMailboxPathScript = fs.readFileSync(__dirname + '/lua/z-get-mailbox-path.lua', 'utf-8');

redis.defineCommand('zExpunge', {
    numberOfKeys: 2,
    lua: zExpungeScript
});

redis.defineCommand('zSet', {
    numberOfKeys: 1,
    lua: zSetScript
});

redis.defineCommand('zGet', {
    numberOfKeys: 1,
    lua: zGetScript
});

redis.defineCommand('zGetByUid', {
    numberOfKeys: 1,
    lua: zGetByUidScript
});

redis.defineCommand('zGetMailboxId', {
    numberOfKeys: 2,
    lua: zGetMailboxIdScript
});

redis.defineCommand('zGetMailboxPath', {
    numberOfKeys: 1,
    lua: zGetMailboxPathScript
});

module.exports.redis = redis;
module.exports.notifyQueue = notifyQueue;
