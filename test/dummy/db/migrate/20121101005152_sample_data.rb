class SampleData < ActiveRecord::Migration
  def up
    execute "drop table if EXISTS myreplicator.my_test"

    sql =<<EOT

CREATE  TABLE IF NOT EXISTS `myreplicator`.`my_test` (
  `id` INT NULL AUTO_INCREMENT ,
  `desc` VARCHAR(45) NULL ,
  `updated_at` DATETIME NULL ,
  PRIMARY KEY (`id`) );

EOT
    execute sql
    
    execute "INSERT INTO `myreplicator`.`my_test` (`id`, `desc`, `updated_at`) VALUES (1, 'test 1', '2012-10-31 10:10:00');"
    execute "INSERT INTO `myreplicator`.`my_test` (`id`, `desc`, `updated_at`) VALUES (2, '2', '2012-10-31 10:11:00');"

    Myreplicator::Export.new(:source_schema => "myreplicator",
                             :destination_schema => "dummy",
                             :table_name => "my_test",
                             :incremental_column => "updated_at",
                             :cron => "2 * * * *").save!                        
  end

  def down
    execute "drop table if EXISTS myreplicator.my_test"

    execute "truncate myreplicator.myreplicator_exports"
  end
end