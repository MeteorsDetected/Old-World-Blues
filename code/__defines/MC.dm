
//! SUBSYSTEM STATES
#define SS_IDLE 0		/// aint doing shit.
#define SS_QUEUED 1		/// queued to run
#define SS_RUNNING 2	/// actively running
#define SS_PAUSED 3		/// paused by mc_tick_check
#define SS_SLEEPING 4	/// fire() slept.
#define SS_PAUSING 5 	/// in the middle of pausing
