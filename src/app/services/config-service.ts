// Copyright (c) 2018 Queensland Cyber Infrastructure Foundation (http://www.qcif.edu.au/)
//
// GNU GENERAL PUBLIC LICENSE
//    Version 2, June 1991
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along
// with this program; if not, write to the Free Software Foundation, Inc.,
// 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

import { Injectable, Inject} from '@angular/core';
import { Location } from '@angular/common';
import { HttpClient, HttpResponse } from '@angular/common/http';
import { Subject } from 'rxjs/Subject';

/**
 * Handles client-side global configuration
 *
 * Author: <a href='https://github.com/shilob' target='_blank'>Shilo Banihit</a>
 *
 */
@Injectable()
export class ConfigService {
  protected config: any;
  protected subjects: any;

  constructor (@Inject(HttpClient) protected http: any, protected location: Location) {
    this.subjects = {};
    this.subjects['get'] = new Subject();
    this.initConfig();
  }

  getConfig(handler: any): any {
    if (this.config) {
      handler(this.config);
      return null;
    } else {
      const subs = this.subjects['get'].subscribe(handler);
      this.emitConfig();
      return subs;
    }
  }

  emitConfig() {
    if (this.config) {
      this.subjects['get'].next(this.config);
    }
  }

  initConfig() {
    const url = this.location.prepareExternalUrl(`assets/config.json?v=${new Date().getTime()}`);
    this.http.get(url, {observe:'response'}).subscribe((res:any) => {
      this.config = this.extractData(res);
      console.log(`ConfigService, initialized. `);
      this.emitConfig();
    });
  }

  protected extractData(res: HttpResponse<any>, parentField: any = null) {
    let body = res.body;
    if (parentField) {
        return body[parentField] || {};
    } else {
        return body || {};
    }
  }
}
