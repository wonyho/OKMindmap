function paginate_init(url, page, pages){
	var paginateHtml = '';
	var offset = Math.floor(15 / 2);
	var start = Math.max(page - offset, 1);
	var end = Math.min(Math.min(page + offset, pages) + Math.max(offset - (page - start), 0), pages);
	start = Math.max(start - Math.max(offset - (end - page), 0), 1);
	if(page > 1) paginateHtml += '<li class="page-item"><a class="page-link" href="'+url+'1" onclick="fetchData('+url+');"><span aria-hidden="true">&laquo;</span></a></li>';
	for (var i = start; i <= end; i++) {
		paginateHtml += '<li class="page-item '+(i == page ? 'active':'')+'"><a class="page-link" href="'+url+i+'" >'+i+'</a></li>';
	}
	if(page < pages) paginateHtml += '<li class="page-item"><a class="page-link" href="'+url+page+'" ><span aria-hidden="true">&raquo;</span></a></li>';
	$('.paginate-html').html(paginateHtml);
}