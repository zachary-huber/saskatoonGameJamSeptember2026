class_name RunStats extends Resource


enum runCompletionStatusType {
	inProgress,
	completed,
	abandoned,
	failed,
	notStarted
}

@export var runTimeDurationTicks:int = 0
@export var runCompletionStatus:runCompletionStatusType = runCompletionStatusType.inProgress
@export var numJumps:int = 0
@export var numRuns:int = 0
