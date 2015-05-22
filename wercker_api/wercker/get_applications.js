'use strict';
var format   = require('util').format;

function get_applications(cb) {
    var get_obj, url;
    url = format('/api/%s', this.constant.PATH_GET_APPLICATIONS);
    get_obj = {
        "token": this.token
    };

    this.req.do_get(url, get_obj, cb);
}

module.exports = get_applications;
