//= require jquery.maskMoney.min

$(document).on('rails_admin.dom_ready', function(){

var options =  {prefix:'R$ ', allowNegative: true, thousands:'.', decimal:',', affixesStay: true}

 $("#contract_start_value").maskMoney(options);
 $("#amendment_amendment_value").maskMoney(options);
 $("#budget_value").maskMoney(options);
 $("#invoice_value").maskMoney(options);
 $("#service_order_value").maskMoney(options);

 });
