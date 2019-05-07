# frozen_string_literal: true

require 'spec_helper'
require 'generator_spec'

project_root = File.join(__dir__, * ['..'] * 5)
require File.join(project_root, * %w(lib generators qa local tables tables_generator))

describe Qa::Local::TablesGenerator, type: :generator do
  destination File.join(project_root, '.internal_test_app')

  # before(:all) do
  #   require 'byebug'
  #   byebug
  #   prepare_destination
  #   run_generator
  # end

  it "creates a local_authority model" do
    assert_file 'app/models/qa/local_authority.rb'
  end

  it "creates a local_authority_entry model" do
    assert_file 'app/models/qa/local_authority_entry.rb',
      "class Qa::LocalAuthorityEntry < ApplicationRecord\n" \
      "  belongs_to :local_authority\n" \
      "end\n"
  end

  # it "creates a migration for local_authority" do
  #   assert_file 'db/migrate/create_local_authority'
  # end

end
