# encoding: utf-8
require 'spec_helper'

describe 'fcgiwrap.rpm::default' do
  [
    { :platform => 'centos', :version => '6.5' }
  ].each do |i|
    context "#{i[:platform]}/#{i[:version]}" do
      # need to use let instead of cached so mocks will work properly (slower)
      let(:chef_run) do
        ChefSpec::Runner.new(i) do |node|
          # override cookbook attributes
          node.override['fcgiwrap']['pre_tidy'] = true
          node.override['fcgiwrap']['post_tidy'] = true

          # set cookbook attributes
          node.set['fcgiwrap']['devel_packages'] = %w(fcgi package2)
        end.converge(described_recipe)
      end # let

      #---------------------------------------------------------------- locals
      home = Pathname.new('/') + 'home' + 'vagrant'

      #------------------------------------- include_recipe[yum-epel::default]
      describe 'yum-epel' do
        it 'includes described recipe' do
          expect(chef_run).to include_recipe(subject)
        end # it
      end # describe

      #------------------------------------------------------------- package[]
      describe 'automake' do
        it 'installs described package' do
          expect(chef_run).to install_package(subject)
        end # it
      end # describe

      describe 'git' do
        it 'installs described package' do
          expect(chef_run).to install_package(subject)
        end # it
      end # describe

      describe 'pkgconfig' do
        it 'installs described package' do
          expect(chef_run).to install_package(subject)
        end # it
      end # describe

      describe 'rpm-build' do
        it 'installs described package' do
          expect(chef_run).to install_package(subject)
        end # it
      end # describe

      describe 'fcgi-devel' do
        it 'installs described package' do
          expect(chef_run).to install_package(subject)
        end # it
      end # describe

      describe 'package2-devel' do
        it 'installs described package' do
          expect(chef_run).to install_package(subject)
        end # it
      end # describe

      #-------------------------------------------------------- bash[pre_tidy]
      describe 'pre_tidy' do
        it 'runs described bash script' do
          expect(chef_run).to run_bash(subject)
        end # it
      end # describe

      #----------------------------- directory[/home/vagrant/rpmbuild/SOURCES]
      describe '/home/vagrant/rpmbuild/SOURCES' do
        it 'creates directory with expected owner, group' do
          expect(chef_run).to create_directory(subject)
            .with_owner('vagrant').with_group('vagrant').with_recursive(true)
        end # it
      end # describe

      #------------------------------- directory[/home/vagrant/rpmbuild/SPECS]
      describe '/home/vagrant/rpmbuild/SPECS' do
        it 'creates directory with expected owner, group' do
          expect(chef_run).to create_directory(subject)
            .with_owner('vagrant').with_group('vagrant').with_recursive(true)
        end # it
      end # describe

      #------------------------------------ bash[chown /home/vagrant/rpmbuild]
      describe 'chown /home/vagrant/rpmbuild' do
        it 'runs described bash script if directory exists' do
          allow_any_instance_of(Pathname).to receive(:directory?)
            .and_return(true)
          expect(chef_run).to run_bash(subject).with_user(nil)
            .with_group(nil)
        end # it

        it 'does not run described bash script unless directory exists' do
          allow_any_instance_of(Pathname).to receive(:directory?)
            .and_return(false)
          expect(chef_run).to_not run_bash(subject)
        end # it
      end # describe

      #-------------------------------------------------------- bash[git_pull]
      describe 'git_pull' do
        it 'runs described bash script' do
          allow_any_instance_of(Pathname).to receive(:directory?)
            .and_return(true)
          expect(chef_run).to run_bash(subject).with_user('vagrant')
            .with_group('vagrant')
        end # it

        it 'does not run described bash script' do
          allow_any_instance_of(Pathname).to receive(:directory?)
            .and_return(false)
          expect(chef_run).to_not run_bash(subject)
        end # it
      end # describe

      #------------- bash[git_clone https://github.com/schnell18/fcgiwrap.git]
      describe 'git_clone https://github.com/schnell18/fcgiwrap.git' do
        it 'runs described bash script' do
          allow_any_instance_of(Pathname).to receive(:directory?)
            .and_return(false)
          expect(chef_run).to run_bash(subject).with_user('vagrant')
            .with_group('vagrant')
        end # it

        it 'does not run described bash script' do
          allow_any_instance_of(Pathname).to receive(:directory?)
            .and_return(true)
          expect(chef_run).to_not run_bash(subject)
        end # it
      end # describe

      #----------------------------------------------------- bash[git_archive]
      describe 'git_archive' do
        it 'runs described bash script' do
          expect(chef_run).to run_bash(subject).with_user('vagrant')
            .with_group('vagrant')
        end # it
      end # describe

      #-------------------------------------------------------- bash[rpmbuild]
      describe 'rpmbuild' do
        it 'runs described bash script' do
          expect(chef_run).to run_bash(subject)
            .with_user('vagrant').with_group('vagrant')
            .with_environment('HOME' => home.to_s)
        end # it
      end # describe

      #--------------------------------------------- bash[copy_final_products]
      describe 'copy_final_products' do
        it 'runs described bash script if directory exists' do
          allow_any_instance_of(Pathname).to receive(:directory?)
            .and_return(true)
          expect(chef_run).to run_bash(subject)
            .with_user('vagrant').with_group('vagrant')
        end # it

        it 'does not run described bash script' do
          allow_any_instance_of(Pathname).to receive(:directory?)
            .and_return(false)
          expect(chef_run).to_not run_bash(subject)
        end # it
      end # describe

      #------------------------------------------------------- bash[post_tidy]
      describe 'post_tidy' do
        it 'runs described bash script' do
          expect(chef_run).to run_bash(subject)
        end # it
      end # describe

    end # context
  end # [...].each

end # describe
