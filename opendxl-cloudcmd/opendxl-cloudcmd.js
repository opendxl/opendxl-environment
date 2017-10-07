#!/usr/bin/env node

'use strict';

// Wrapper script for loading the cloudcmd app in an express web server,
// under http or https depending upon configuration settings

const CLOUDCMD_BASE_CONFIG = 'cloudcmd.json';
const CLOUDCMD_HTTPS_CONFIG = 'cloudcmd-https.json';

const cloudcmd = require('cloudcmd');
const http = require('http');
const https = require('https');
const fs = require('fs');
const express = require('express');
const io = require('socket.io');
const minimist = require('minimist');
const path = require('path');

const DEFAULT_CONFIG_DIR = '/opendxl/config/webconsole';

const argv = process.argv;
const args = minimist(argv.slice(2), {
    string: [
        'config-dir'
    ],
    boolean: [
        'help'
    ],
    default: {
        'config-dir': DEFAULT_CONFIG_DIR
    },
    alias: {
        c: 'config-dir',
        h: 'help'
    },
    unknown: (cmd) => {
        exit('\'%s\' is not an opendxl-cloudcmd option. %s',
            cmd, 'See \'opendxl-cloudcmd --help\'.');
    }
})

function exit() {
    console.error.apply(console, arguments);
    process.exit(1);
}

function help() {
    console.log('Usage: opendxl-cloudcmd [options]');
    console.log('Options:');
    console.log('  -h, --help        display this help and exit')
    console.log('  -c, --config-dir  directory in which config files reside')
    console.log('                      (default is \'%s\')', DEFAULT_CONFIG_DIR)
}

function adjustedPrefix(value) {
    if (typeof(value) !== 'string')
        return '';

    if (value.length === 1)
        return '';

    if (value && !~value.indexOf('/'))
        return '/' + value;

    return value;
}

function loadConfigFile(fileName) {
    let jsonText;
    try {
        jsonText = fs.readFileSync(fileName, 'utf-8');
    } catch (e) {
        if (e.code === 'ENOENT') {
            console.log("Config file (%s) not found, using defaults",
                fileName);
            jsonText = '{}';
        } else {
            exit('Error reading config file (%s): %s, exiting...',
                fileName, e);
        }
    }

    let jsonObject;
    try {
        jsonObject = JSON.parse(jsonText);
    } catch (e) {
        exit('Error parsing JSON from config file (%s): %s, exiting...',
            fileName, e);
    }

    return jsonObject;
}

function slurp(fileName, fileDescription) {
    if (!fileName) {
        exit('File name not configured for %s, exiting...',
            fileDescription);
    }

    let fileContents;
    try {
        fileContents = fs.readFileSync(fileName, 'utf-8');
    } catch (e) {
        exit('Error reading %s file (%s): %s, exiting...',
            fileDescription, fileName, e);
    }
    return fileContents;
}

function main() {
    const baseCloudCmdConfig = loadConfigFile(path.join(args['config-dir'],
        CLOUDCMD_BASE_CONFIG));
    const httpsCloudCmdConfig = loadConfigFile(path.join(args['config-dir'],
        CLOUDCMD_HTTPS_CONFIG));

    const port = baseCloudCmdConfig['port'];
    if (port < 0 || port > 65535)
        exit('Invalid port (%s). %s. %s.', port,
            'Port must be >= 0 and < 65536',
            'For 0, an available port is chosen');

    const ip = baseCloudCmdConfig['ip'] || '0.0.0.0';
    const prefix = adjustedPrefix(baseCloudCmdConfig['prefix']);
    const app = express();

    let server;
    let scheme;
    if (httpsCloudCmdConfig['https']) {
        scheme = 'https';
        const privateKey = slurp(httpsCloudCmdConfig['private_key'],
            'private key');
        const certificate = slurp(httpsCloudCmdConfig['cert'], 'certificate');
        const credentials = {key: privateKey, cert: certificate};
        server = https.createServer(credentials, app);
    } else {
        scheme = 'http';
        server = http.createServer(app);
    }

    app.use([cloudcmd({
        socket: io(server, {
            path: `${prefix}/socket.io`
        }),
        config: baseCloudCmdConfig
    })]);

    server.listen(port, ip, () => {
        const host = baseCloudCmdConfig['ip'] || 'localhost';
        const assignedPort = port || server.address().port;
        const url = `${scheme}://${host}:${assignedPort}${prefix}/`;

        console.log('url:', url);
    });

    server.on('error', error => {
        exit('opendxl-cloudcmd server error: %s, exiting...',
            error.message);
    });
}

if (args.help)
    help();
else
    main();
