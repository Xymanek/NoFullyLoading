class UIBetterRedScreen extends UIRedScreen;

const FULLY_LOADING_PREFIX = "FullyLoading in DynamicLoadObject";
const FULLY_LOADING_PREFIX_LEN = 33;

var int PrevNumLines;

simulated event PostRenderFor(PlayerController kPC, Canvas kCanvas, vector vCameraPosition, vector vCameraDir)
{
	if (PrevNumLines != RedscreenLines.Length)
	{
		CheckForFullyLoading();
	}

	if (!bIsRemoved)
	{
		super.PostRenderFor(kPC, kCanvas, vCameraPosition, vCameraDir);
	}
}

simulated function CheckForFullyLoading ()
{
	local int Index;

	for (Index = RedcreenShowOffset; Index < RedscreenLines.Length; ++Index)
	{
		`log("Testing" @ RedscreenLines[Index],, 'NoFullyLoading');

		if (Left(RedscreenLines[Index], FULLY_LOADING_PREFIX_LEN) == FULLY_LOADING_PREFIX)
		{
			`log("Removing" @ RedscreenLines[Index],, 'NoFullyLoading');
			
			RedscreenLines.Remove(Index, 1);
			Index--;
		}
	}

	JoinArray(RedscreenLines, m_strErrorMsg, "\n", false);

	// Check if we got rid of everything to show
	if (RedcreenShowOffset >= RedscreenLines.Length)
	{
		CloseScreen();
	}

	PrevNumLines = RedscreenLines.Length;
}