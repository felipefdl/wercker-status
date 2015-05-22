'use strict';
var request  = require('request');
var qs       = require('querystring');
var format   = require('util').format;
var constant = require('../constant.json');

function do_post(path, data, cb) {
    var url, result;
    url = format('%s/%s', constant.DEFAULT_WERCKER_URL, path);

    request.post({ 'url': url, 'form': data }, function (err, r, b) {
        try {
            result = JSON.parse(b);
        } catch (e) {
            cb(err || e);
        }

         cb(null, result);
     });
}

function do_get(path, params, cb) {
    var url, result;
    url = format('%s/%s?%s', constant.DEFAULT_WERCKER_URL, path, qs.stringify(params));

    request.get({ 'url': url }, function (err, r, b) {
        try {
            result = JSON.parse(b);
        } catch (e) {
            cb(err || e);
        }

         cb(null, result);
     });
}

exports.do_post = do_post;
exports.do_get  = do_get;
