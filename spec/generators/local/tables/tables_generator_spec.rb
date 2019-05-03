require 'spec_helper'

describe 'Qa::Local::TablesGenerator' do
  describe 'migrations' do
    before do
      @target_files = %w(local_authority local_authority_entry)
    end
    after do
      # clean up changes
    end
    it 'should generate local models' do
      # rails.root is ./.internal_test_app, so run generator commands from there
      Dir.chdir(Rails.root) do
        require 'byebug'
        byebug

        expect do
          system 'bundle exec rails generate qa:local:tables'
        end.to_not raise_error
      end
      # expect(subject).to receive(generate)
    end
  end
end

# class TablesGeneratorTest < Rails::Generators::TestCase
#   # tests TablesGenerator
#   destination File.expand_path(Rails.root.join '.internal_test_app')

#   describe 'migrations' do
#     it 'should generate local models' do
#       require 'byebug'
#       byebug
      
#       # expect(subject).to receive(generate)
#     end
#   end
# end
