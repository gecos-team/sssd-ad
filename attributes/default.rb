#
# Cookbook Name:: sssd_ad
# Attribute:: default
#
# Copyright 2013, Limelight Networks, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['sssd_ad']['domain'] = node[:fqdn].split('.').drop(1) * "."
default['sssd_ad']['workgroup'] = node['sssd_ad']['domain'].split('.').first.upcase
default['sssd_ad']['realm'] = node['sssd_ad']['domain'].upcase
