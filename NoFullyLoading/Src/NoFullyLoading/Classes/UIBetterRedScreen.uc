class UIBetterRedScreen extends UIRedScreen;

const FULLY_LOADING_PREFIX = "FullyLoading in DynamicLoadObject";
const FULLY_LOADING_PREFIX_LEN = 33;

var int PrevNumLines;

simulated event PostRenderFor(PlayerController kPC, Canvas kCanvas, vector vCameraPosition, vector vCameraDir)
{
	local XComEngine Engine;	

	if (PrevNumLines != RedscreenLines.Length)
	{
		ValidateLines();

		// This is required to prevent the manager from resetting the message
		Engine = XComEngine(class'Engine'.static.GetEngine());
		Engine.m_RedScreenManager.m_currentErrors = m_strErrorMsg;
	}

	if (!bIsRemoved)
	{
		super.PostRenderFor(kPC, kCanvas, vCameraPosition, vCameraDir);
	}
}

simulated function ValidateLines ()
{
	local int Index;

	// Check for FullyLoading
	for (Index = RedcreenShowOffset; Index < RedscreenLines.Length; ++Index)
	{
		`log("Testing:" @ RedscreenLines[Index],, 'NoFullyLoading');

		if (Left(RedscreenLines[Index], FULLY_LOADING_PREFIX_LEN) == FULLY_LOADING_PREFIX)
		{
			`log("Removing:" @ RedscreenLines[Index],, 'NoFullyLoading');
			
			RedscreenLines.Remove(Index, 1);
			Index--;
		}
	}

	// Check for empty line(s) at the end
	for (Index = RedscreenLines.Length - 1; Index > RedcreenShowOffset; Index--)
	{
		if (RedscreenLines[Index] == "")
		{
			`log("Removing empty line at the end",, 'NoFullyLoading');
			RedscreenLines.Remove(Index, 1);
		}
		else
		{
			break;
		}
	}

	JoinArray(RedscreenLines, m_strErrorMsg, "\n", false);

	// Check if we got rid of everything to show
	if (RedcreenShowOffset >= RedscreenLines.Length)
	{
		`log("Cleaned redscreen of all messages, so closing it",, 'NoFullyLoading');
		CloseScreen();
	}

	PrevNumLines = RedscreenLines.Length;
}