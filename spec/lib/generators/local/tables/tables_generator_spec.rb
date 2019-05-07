# frozen_string_literal: true

require 'spec_helper'
require 'generator_spec'

project_root = File.join(__dir__, * ['..'] * 5)
require File.join(project_root, 'lib', 'generators', 'qa', 'local', 'tables', 'tables_generator')

describe Qa::Local::TablesGenerator, type: :generator do
  destination File.join(project_root, '.internal_test_app')

  # before(:all) do
  #   require 'byebug'
  #   byebug
  #   prepare_destination
  #   run_generator
  # end

  it "creates a local_authority model" do
    assert_file 'app/models/qa/local_authority.rb',
                webmock_fixture('models/local_authority.rb')
  end

  it "creates a local_authority_entry model" do
    assert_file 'app/models/qa/local_authority_entry.rb',
                webmock_fixture('models/local_authority_entry.rb')
  end
end
