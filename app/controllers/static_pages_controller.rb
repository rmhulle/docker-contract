class StaticPagesController < ApplicationController
  def home
    #code
  end

  def aceptance_email
    
  end

  def map_reduce
    map= %Q{
      function() {
        emit(this.name, {count: 1, price: 2, requesting: this.requesting, vendor: this.vendor_id} );
      }
    }


    reduce = %Q{
      function(key, values) {
        var result = { count: 0,
                       price: 0,
                       requesting: "",
                       vendor: ""};
        values.forEach(function(value) {
          result.count += value.count;
          result.price  += value.price;
          result.requesting = value.requesting;
          result.vendor = {$in : db.vendors.findOne({"_id" : vendor})};

        });
        return result;
      }
    }

    @bi_map = Contract.includes(:vendor).map_reduce(map, reduce).out(replace: "bi_db")

  end


  def report

    map = %Q{
      function() {
        emit(this.object_type, 1 );
      }
    }



    reduce = %Q{
      function(key, values) {
        var result =  0 ;
        values.forEach(function(value) {
          result += value;
        });
        return result;
      }
    }
    contracts = Contract.map_reduce(map, reduce).out(replace: "Full")

  end
end
