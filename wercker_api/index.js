'use strict';
var constant = require('./constant.json');

function Wercker(settings) {
    settings = settings || {};

    this.api_version = settings.api_version || constant.API_VERSION;
    this.token       = settings.token       || "";
    this.constant    = constant;
}

Wercker.prototype.req                 = require('./infrastructure/req.js');
Wercker.prototype.get_builds          = require('./wercker/get_builds.js');
Wercker.prototype.get_applications    = require('./wercker/get_applications.js');
Wercker.prototype.request_oauth_token = require('./wercker/request_oauth_token.js');

module.exports = Wercker;
