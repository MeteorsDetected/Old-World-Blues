/**
  * The absolute base class for everything
  *
  * A datum instantiated has no physical world prescence, use an atom if you want something
  * that actually lives in the world
  *
  * Be very mindful about adding variables to this class, they are inherited by every single
  * thing in the entire game, and so you can easily cause memory usage to rise a lot with careless
  * use of variables at this level
  */
/datum
	/**
	  * Tick count time when this object was destroyed.
	  *
	  * If this is non zero then the object has been garbage collected and is awaiting either
	  * a hard del by the GC subsystme, or to be autocollected (if it has no references)
	  */
	var/gc_destroyed






	/// Components attached to this datum
	/// Lazy associated list in the structure of `type:component/list of components`
	var/list/datum_components
	/// Any datum registered to receive signals from this datum is in this list
	/// Lazy associated list in the structure of `signal:registree/list of registrees`
	var/list/comp_lookup
	/// Lazy associated list in the structure of `signals:proctype` that are run when the datum receives that signal
	var/list/signal_procs
	/// Is this datum capable of sending signals?
	/// Set to true when a signal has been registered
	var/signal_enabled = FALSE

// Default implementation of clean-up code.
// This should be overridden to remove all references pointing to the object being destroyed.
// Return the appropriate QDEL_HINT; in most cases this is QDEL_HINT_QUEUE.
/datum/proc/Destroy(force=FALSE, ...)
	tag = null



	return QDEL_HINT_QUEUE