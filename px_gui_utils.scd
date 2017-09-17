// px gui utils

~addGuiFunc = { arg e, proxy_list, stethoscope_prox;
	var calling_env = currentEnvironment;
	~edit = { arg e, parent;
		e.use {
			~view = parent ?? Window.new(scroll: true);
			~view.addFlowLayout( 10@10, 20@5 );
			proxy_list.do({ arg proxy;
				var text = proxy.displayName ++ ": " ++ proxy.class;
				StaticText(~gui.view, Rect(0, 0, 400, 20)).string_(text);
				proxy.edit(parent: ~view.view);
				});
			if (stethoscope_prox.notNil, {
				Stethoscope.new(s, 2, stethoscope_prox.bus.index, view: ~view.view);
			});
			~view.front;
		}
	}
};



~addExpandingGuiFunc = { arg e, proxy_list;
	var calling_env = currentEnvironment;
	~edit = { arg e, parent;
		e.use {
			// ~view = parent ?? Window.new( ~path.basename, Rect(128,64,208,220));
			var smallBounds = 400@16;
			var view = parent ?? Window.new(~path.basename, Rect(128,64,208,220), scroll: true);
			view.asView.addFlowLayout;
			proxy_list.collect({ arg proxy;
				var text = proxy.displayName ++ ": " ++ proxy.class;
				var e = ExpandViewLabel(view, 400@200, smallBounds, label: text);
				var prox_view = proxy.edit(parent: e.composite);
				// prox_view.bounds.postln;
				e.bigBounds = Rect(0, 0, smallBounds.x, prox_view.bounds.height);
				});
			view.front;
		}
	}
};



// ~addExpandingGuiFunc = { arg e, proxy_list;
// 	var calling_env = currentEnvironment;
// 	~edit = { arg e, parent;
// 		e.use {
// 			// ~view = parent ?? Window.new( ~path.basename, Rect(128,64,208,220));
// 			var view = parent ?? ScrollView(bounds: Rect(128,64,208,220))
// 			var layout;
// 			var makeEntries = proxy_list.collect({ arg proxy;
// 					var text = proxy.displayName ++ ": " ++ proxy.class;

// 			}
// 			view.asView.addFlowLayout;
// 			proxy_list.collect({ arg proxy;
// 				var text = proxy.displayName ++ ": " ++ proxy.class;
// 				var e = ExpandViewLabel(view, 350@200, 350@16, label: text);
// 				proxy.edit(parent: e, bounds: Rect(0, 20, e.bigBounds.width - 20, e.bigBounds.height - 20));
// 				});
// 			view.front;
// 			~view = view;
// 		}
// 	}
// };



~addTabbedGuiFunc = { arg e, view_list;
	var calling_env = currentEnvironment;
	~edit = { arg e, parent;
		e.use {
			~view = parent ?? TabbedView2.new;
			view_list.do({ arg view_item;
				~view.add(view_item.name).flow({ arg w;
					w.addFlowLayout( 10@10, 20@5 );
					view_item.proxies.do({ arg proxy;
						var text = proxy.displayName ++ ": " ++ proxy.class;
						StaticText(w.view, Rect(0, 0, 400, 20)).string_(text);
						proxy.edit(parent: w.view);
						});
					})
				});
			~view.refresh;
		}
	}
};
