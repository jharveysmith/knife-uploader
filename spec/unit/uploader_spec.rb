# Copyright (C) 2013 ClearStory Data, Inc.
# All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

$:.unshift File.expand_path('../../lib', __FILE__)

require 'chef'
require 'chef/knife/uploader'
require 'json'

describe KnifeUploader::Utils do
  describe '.sort_hash_keys' do

    it 'Ruby normally keeps track of hash key order' do
      {:a => 1, :c => 3, :b => 2}.keys.should == [:a, :c, :b]
    end

    it 'should return a hash with sorted keys' do
      KnifeUploader::Utils.sort_hash_keys({:a => 1, :c => 3, :b => 2}).keys.should == [:a, :b, :c]
    end
  end

  describe '.recursive_sort_hash_keys' do
    before do
      @hash = {:c => {:zz => 3, :ww => 5, :aa => 17}, :b => 5, :asdf => { :d => 7, :a => 100 }}
    end

    it 'JSON keys should come in the same order as specified' do
      JSON.generate(@hash).should == '{"c":{"zz":3,"ww":5,"aa":17},"b":5,"asdf":{"d":7,"a":100}}'
    end

    it 'should sort keys at every level' do
      new_hash = @hash
      JSON.generate(KnifeUploader::Utils.recursive_sort_hash_keys(new_hash)).should ==
        '{"asdf":{"a":100,"d":7},"b":5,"c":{"aa":17,"ww":5,"zz":3}}'
      # There should be no side effects on the hash being sorted.
      new_hash.should == @hash
    end
  end
end
