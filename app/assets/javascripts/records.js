
/*global jQuery*/
jQuery(function ($) {
	function redirect(url) {
		return 'http://redirect.cvt.dk/?url=' + encodeURIComponent(url);
	}

	function collapseRecord(record) {
		var isShort = $('#records').hasClass('short'),
			expandIcon = record.find('.icon-expand'),
			collapseIcon = record.find('.icon-collapse'),
			firstAbstract = record.find('.abstract:first'),
			original = firstAbstract.text();
		
		if (isShort) {
			record.find('.normal-view, .detailed-view').hide();
			record.parent().siblings().children('img').hide();
		} else {
			record.find('.detailed-view').hide();
			firstAbstract.text(firstAbstract.text().split(/\s/).splice(0, 100).join(' ') + (original === 'No abstract available.' ? ' ' : '... '));
			firstAbstract.show();
		}

		collapseIcon.hide();
		expandIcon.show();
	}
	
	$('.cover-image').each(function () {
		var coverImage = $(this),
			isShort = $('#records').hasClass('short');

		if (!isShort) {
			var recordIds = $(this).attr('record_id'),
			    type = $(this).attr('type'),
			    title = $(this).attr('title');
			$.ajax({
                dataType: 'html',
				url: 'cover/?id=' + recordIds + '&type=' + type + '&title=' + title,
				success: function (data, status) {
					coverImage.html(data);
				},
				error: function (request, status, thrown) {
					// error
				}
			});
		}
	});

	if (configuration.enabledFeatures.tagging) {
		$('.remove-tag').click(function () {
			var tag = $(this).parent();
			var removeTagLink = this;
			
			$.ajax({
				dataType : 'html',
				url : $(this).attr('href'),
				success : function () {
					// Find the tag's ID from the a href
					var tagId = $(removeTagLink).attr('href').match(/tagId=(\d+)/)[1];
					// Find the tag's count in the "Resources by tag" menu
					var tagCountElementSelector = '#tag-count-' + tagId + ' .total';
					var tagCountElement = $(tagCountElementSelector);
					var tagCount;
		
					// Get the new tag count
					tagCount = ($(tagCountElement).text().match(/\((\d+)\)/)[1]) - 1;
					
					if (tagCount == 0) {
						// Remove tag from "Resources by type"
						// TODO: This is not consistent with the way
						// "Resources by type" is displayed but "empty" tags can quickly clutter the list
						if (!$(tagCountElement).parent().find('a').hasClass('inactive')) {
							$('#facets .tag-count a').removeClass('inactive');
						}
						$(tagCountElement).parent().remove();
					}
					
					$(tagCountElement).text('(' + tagCount + ')');
					if ($(tagCountElement).parent().find('a').hasClass('inactive')) {
						// This tag is not the "active" tag so we just remove it from the record
						$(tag).remove();
					} else {
						// This is the "active" tag so the whole record should be removed from the list
						// This assumes a structure like for example "li > ul > li > .record" for each record
						// TODO: Top element containing a record should have a marker to avoid this evil parent().parent()... stuff
						$(tag).closest('.record').parent().parent().parent().remove();
					}
				},
				error : function () {
					alert('Error performing operation. Please try again later.');
				}
			});
			
			return false;
		});
	}
	
	$('#documents .document').each(function () {
		var record = $(this),
			firstAbstract = $(this).find('.abstract:first'),
			original = firstAbstract.text(),
			expandIcon = $(this).find('.icon-expand'),
			collapseIcon = $(this).find('.icon-collapse'),
			clicked = false,
			recommended = false;

		collapseIcon.hide();

		collapseIcon.click(function () {
			collapseRecord(record);
			return false;
		});

		expandIcon.click(function () {
			var toc = record.find('.toc'),
				recommendations = record.find('.recommendations');

			firstAbstract.text(original);
			firstAbstract.show();

			record.find('.normal-view, .detailed-view').show();

			if(recommended) {
				recommendations.show();
			}

			expandIcon.hide();
			collapseIcon.show();

			if (!clicked) {
				// ToC
				toc.find('p').hide();
				toc.append('<p><img src="/images/ajax-loader.gif"/> Checking for table of contents, please wait a few moments.</p>');
				toc.find('a[rel = "related"]').each(function () {
					var tocUrl = this.href;
					$.ajax({
						dataType: "html",
						url: tocUrl,
						success: function (data, status) {
							if (status === 'success' && data !== undefined) {
								toc.find('p').remove();
								toc.append(data);
								toc.show();
							} else {
								toc.find('p').remove();
	            				toc.append('<p>No table of contents found.</p>');
							}
						},
						error: function (request, status, error) {
	            			request.abort();
	            			toc.find('p').remove();
	            			toc.append('<p>No table of contents found.</p>');
	            		}
					});
				});

				// Recommendations
				recommendations.hide();
				recommendations.find('a[rel = "related"]').each(function () {
					var bxpUrl = this.href;

					$.ajax({
						url: bxpUrl,
						success: function (data, status) {
							if (status === 'success' && data !== undefined && data.page && data.page.recommendation) {
								recommended = true;

								$.each(data.page.recommendation, function (index, r) {
									var query = '/search?q=' + (typeof r['rft.atitle'] !== 'undefined' ? 'title:' + encodeURIComponent('"' + r['rft.atitle'] + '"') : ''),
										q = [];

									$.each(r, function (key, value) {
										if (key.startsWith('rft')) {
											q.push(key + '=' + encodeURIComponent(value));
										}
									});

									$.ajax({
										url: '/sfxp/resolve?' + q.join('&'),
										success: function (data, status) {
											var target, url, title, tmpTitle = [];

											if (status === 'success' && data !== undefined && data.page && data.page.target) {

												target = data.page.target[0];

												if (recommendations.find('p').size() > 0) {
													recommendations.find('p').remove();
													recommendations.append('<ul></ul>');
													recommendations.show();
												}

												if (r['rft.jtitle']) {
													title = ' <span>(' + r['rft.jtitle'];
													if (r['rft.year']) {
														tmpTitle.push(r['rft.year']);
													}
													if (r['rft.volume']) {
														tmpTitle.push('Volume ' + r['rft.volume']);
													}
													if (r['rft.issue']) {
														tmpTitle.push('Issue ' + r['rft.issue']);
													}
													if (r['rft.spage'] && r['rft.epage']) {
														tmpTitle.push('pp. ' + r['rft.spage'] + '-' + r['rft.epage']);
													}
													if (tmpTitle.length > 0) {
														title += ' — ' + tmpTitle.join(', ');
													}
													title += ')</span>';
												}

												recommendations.find('ul').append('<li><a target="_blank" href="' +
													redirect(target.url) +
													'">' +
													r['rft.atitle'] +
													(title ? title : '') +
													'</a></li>');
											}
										},
										error: function (request, status, error) {
	            							request.abort();
	            						}
									});
								});
							}
						},
						error: function (request, status, error) {
	            			request.abort();
	            		}
	            	});
				});

				clicked = true;
			}
			return false;
		});

		collapseRecord(record);
		
		/*
		if (isShort) {
			// Hide everything not marked with short-view class
			record.children().not('.short-view, .tools, .tagging, .icon-expand, .icon-collapse').hide();
			record.parent().siblings().children('img').hide();
		} else if (firstAbstract.length == 0) {
			$('.authors').nextAll().not('.tools, .tagging').hide();
		} else {
			// hide everything coming after the abstract except the tool bar.
			firstAbstract.nextAll().not('.tools, .tagging').hide();
			firstAbstract.text(firstAbstract.text().split(/\s/).splice(0, 100).join(' ') + (original === 'No abstract available.' ? ' ' : '... '));
		}
		*/
	});


    // google analytics event tracking on download- and order-actions
    // for each record we track clicks on title or download/order tool-buttons
    // for each event we track
    //   ( action[Order,Download]; doctype[Article,Journal,Book]; url; search result page )
    var recordSetupEventTracking = function(record) {
        try {
            var docType = $(record).find('span.document-type').first().text().replace(/\[(.*)\] /, "$1"),
                page = ($.query.get('page') ? $.query.get('page') : 1);
            //console.log('record;' + docType + ';' + page + ';');

            $(record).find('a.fulltext, .tools a:has(span.download), .tools a:has(span.order)')
                    .each(function() {
                        var url = $(this).attr('href'),
                            action = (url.search(/docdel/) != -1 ? 'Order' : 'Download');
                        //console.log('    ' + action + ';' + url.substring(0, 100) + ';');
                        $(this).click(function() {
                            pageTracker._trackEvent(action, docType, url, page);
                            return true;
                        });
                    });
        } catch (err) {}
    };

    $('.record:has(.title a.fulltext.local, .tools .download, .tools .order)').each(function () {
        recordSetupEventTracking($(this));
    });

    $('.record:has(.tools a.sfx)').each(function() {
        var record = $(this);
		var titleLink = $(this).find('h1.title a.sfx');
		var fullTextLink = $(this).find('.tools a.sfx');
		var noOrder = $(fullTextLink).hasClass('no-order');
		var sfxUrl=$(fullTextLink).attr('sfx');

		var disableLink = function(linkClass, linkText) {
			fullTextLink.html('<span class="' + linkClass + '"/>' + linkText);
			fullTextLink.removeAttr('href');
			titleLink.removeAttr('href');
			fullTextLink.addClass('disabled');
			titleLink.addClass('disabled');
		};

		$.ajax({
			url: sfxUrl,
			success : function (data, status) {
				if (status === 'success' && data !== undefined && data.page && data.page.target) {
					data = eval(data);
					fullTextUrl = data.page.target[0].url;

					var setLink = function(linkClass, linkText) {
                        var temp;
						fullTextLink.attr('href', redirect(fullTextUrl));
						fullTextLink.html('<span class="' + linkClass + '"/>' + linkText);

                        // update title url (with IE workaround)
                        temp=titleLink.html();
						titleLink.attr('href', redirect(fullTextUrl));
                        titleLink.html(temp);
					};

					if (fullTextUrl.indexOf(configuration['docdel.url']) !== -1 ||
					    fullTextUrl.indexOf('https://ext.kb.dk/F')   !== -1) {
						if (noOrder) {
							disableLink('download-disabled', 'Not available');
						} else {
							setLink('order', 'Order');
						}
					} else {
						setLink('download', 'Full text');
					}
				} else {
					disableLink('error', 'Failed');
				}
			},
			error : function (data, status) {
				disableLink('error', 'Failed');
			},
            complete : function () {
                recordSetupEventTracking(record);
            }
		});
	});

	$('#records a.disabled').each(function () {
		// this functionality should go away when /search is refactored to bypass infonet-backend


		var record = $(this).closest('.record'),
            link = this.href,
			element = $(this),
            titleElement=element.parents('#records > li').find('.fulltext');

		this.href = '#';
		element.click(function () {
			return false;
		});
		element.empty();
		element.append('<span class="loading"/>Checking availability...');

		$.ajax({
			url: link,
			success: function (data, status) {
				var r, temp;

				element.empty();
                element.removeClass('disabled');

				if (status === 'success' && data !== undefined && data.page && data.page.target) {
					r = data.page.target[0];

					element.unbind('click');

					// update the download URL
					element.get(0).href = redirect(r.url);

                    // update title url (with IE workaround)
                    temp=$(titleElement).html();
					$(titleElement).attr('href', redirect(r.url));
                    $(titleElement).html(temp);

					if (r.url.indexOf(configuration['docdel.url']) !== -1) {
						element.get(0).title = 'Order article';
						element.append('<span class="order"/>Order');
					} else if (r.url.indexOf('https://ext.kb.dk/F') !== -1) {
						element.get(0).title = 'Order book';
						element.append('<span class="order"/>Order');
					} else {
						element.append('<span class="download"/>Full text');
					}

					// build mapping from labels to urls from sfx response
					var label_to_url = {};
					for (var i=0; i<data.page.target.length; i+=1) {
						var target = data.page.target[i];
						var url = target.url;
						for (var j=0; j<target.label.length; j+=1) {
							var label = target.label[j];
							label_to_url[label] = redirect(url);
						}
					}
					// update expanded fulltext links (based on labels) on journal records
					var record = element.parents('.record');
					record.find('a.sfx_holding').each(function() {
						var label = $(this).attr('label');
						var url = label_to_url[label];
						if (!url) {
							// do nothing - keep link to sfx
						} else {
							$(this).attr('href', url);
						}
					});

            	} else {
            		element.append('<span class="download-disabled"/>Full text');
            	}
            },
            error: function (request, status, error) {
            	request.abort();
                element.parents('#records > li').find('.fulltext').get(0).href = '#';
                element.empty();
            	element.append('<span class="download-disabled"/>Full text');

                // if sfx returns 404, we do not have fulltext access to journal:
                //   remove full-text tool button and set title link to docdel
                if ($(record).hasClass('journal-record')) {
                    element.parent().remove();

                    var orderUrl = $(record).find('a:has(span.order)').attr('href');
                    temp=$(titleElement).html();
                    $(titleElement).attr('href', orderUrl);
                    $(titleElement).html(temp);
                }
                
            },
            complete : function () {
                recordSetupEventTracking(record);
            }
        });
	});

	// admin view of xml
	$('.view-xml').parent().each(function () {
		var viewXml = $(this),
			link = this.href;

		viewXml.click(function () {
			var xmlElm = viewXml.parent().parent().next('.xml');
			if(xmlElm.css('display') == 'none') {
				xmlElm.html('<iframe src="'+ link + '"><p>iframes not supported by browser</p></iframe>');
				viewXml.html('<span class="view-xml"></span>Close XML view');
			}
			else {
				viewXml.html('<span class="view-xml"></span>View XML');
			}
			xmlElm.toggle('fast');
			return false;
		});
	});


});
