require "exporter"

module Myreplicator
  class Transporter
    
    def initialize *args
      options = args.extract_options!
    end

    def tmp_dir
      @tmp_dir ||= File.join(Myreplicator.app_root,"tmp", "myreplicator")
      Dir.mkdir(@tmp_dir) unless File.directory?(@tmp_dir)
      @tmp_dir
    end

    def transfer
      unique_jobs = Export.where("state != 'failed' and active = 1").group("source_schema")
      
      unique_jobs.each do |export|
        download export
      end
    end

    def download export
      ssh = export.ssh_to_source     
      parallel_download(completed_files(ssh, export), ssh)
    end
    
    def parallel_download files, ssh
      for i in 0..files.size do
        files[i]
      end
      files.each do |filename|
        download_file filename, ssh
      end
    end

    def download_file filename, ssh
      Proc.new { sftp = ssh.sftp.connect
        json_file = remote_path(export, filename) 
        json_local_path = File.join(tmp_dir,filename)
        puts "Downloading #{json_file}"
        sftp.download!(json_file, json_local_path)
        dump_file = get_dump_path(json_local_path)
        puts "Downloading #{dump_file}"
        sftp.download!(dump_file, File.join(tmp_dir, dump_file.split("/").last))             
      }
    end

    def completed_files ssh, export
      done_files = ssh.exec!(get_done_files(export))

      unless done_files.blank?
        return done_files.split("\n")
      end

      return []
    end

    def get_dump_path json_path
      metadata = ExportMetadata.new(:metadata_path => json_path)
      return metadata.export_path
    end

    def remote_path export, filename
      File.join(Myreplicator.configs[export.source_schema]["ssh_tmp_dir"], filename)
    end

    def get_done_files export
      cmd = "cd #{Myreplicator.configs[export.source_schema]["ssh_tmp_dir"]}; grep -l export_completed *.json"
    end

    
  end
end
