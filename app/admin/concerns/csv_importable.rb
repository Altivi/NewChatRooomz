module CsvImportable

  require 'csv'
  extend ActiveSupport::Concern

  def self.convert_and_save(model_name, csv_data, params, proc)
    errors = ""
    objects = parse_csv(model_name, csv_data, params, proc)
    objects.each_with_index do |object, i|
      if object.valid?
        object.save
      else
        errors << "#{i.to_s} string :" + object.errors.full_messages.join(', ') + "\n"
      end
    end
    return errors if errors.present?
  end

  def self.parse_csv(model_name, csv_data, params, proc)
    objects = []
    csv_file = csv_data.read
    target_model = model_name.classify.constantize
    CSV.parse(csv_file) do |row|
      new_object = target_model.new
      column_iterator = 0
      params.each do |key|
        unless key == "ID"
          value = row[column_iterator]
          new_object.send "#{key}=", value
        end
        column_iterator += 1
      end
      proc.call new_object if proc.present?
      objects << new_object
    end
    objects
  end

end