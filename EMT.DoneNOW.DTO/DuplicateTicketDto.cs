
namespace EMT.DoneNOW.DTO
{
    public class DuplicateTicketDto
    {
        public bool SameNo;
        public bool SameAlertId;
        public bool SameExter;

        public bool SameTitleConfig;
        public int? SameTitleConfigDay;
        public int? SameTitleConfigHours;
        public int? SameTitleConfigMin;

        public bool SameTitle;
        public int? SameTitleDay;
        public int? SameTitleHours;
        public int? SameTitleMin;

        public bool SameConfig;
        public int? SameConfigDay;
        public int? SameConfigHours;
        public int? SameConfigMin;

        public string actionValue;
        public bool NoteComplete;
        public bool NoteNoComplete;

        public int? CompleteStatusId;
        public int? NoCompleteStatusId;

        public bool IncidentComplete;
        public bool IncidentNoComplete;

    }
}
